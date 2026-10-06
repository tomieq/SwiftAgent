//
//  SessionExecutor.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//
import WebResponse
import Logger
import Foundation

final class SessionExecutor<REQUEST: ModelRequest, RESPONSE: ModelResponse, MESSAGE: ModelMessage>: AISession {
    private var messages: [ModelMessage] = []
    private let logger = Logger("AISession")
    let config: AgentConfig
    let tools: [Tool]?
    let headers: [String: String]
    var usedTokens: Int = 0
    private var lastModel: String?

    init(config: AgentConfig,
         tools: [Tool]?,
         systemMessage: String? = nil) {
        self.config = config
        self.tools = tools

        var headers: [String: String] = [:]
        if let token = config.authToken {
            headers["Authorization"] = "Bearer \(token)"
        }
        self.headers = headers
        if let systemMessage {
            self.messages.append(
                MESSAGE(role: .system,
                        name: nil,
                        toolCallID: nil,
                        content: systemMessage)
            )
        }
    }

    func ask(_ prompt: String, model: String) async throws -> AIResponse {
        messages.append(
            MESSAGE(
                role: .user,
                name: nil,
                toolCallID: nil,
                content: prompt)
        )
        self.lastModel = model
        return try await send(model: model)
    }

    func toolResponse(_ responses: [ToolResponse], model: String) async throws -> AIResponse {
        for response in responses {
            messages.append(
                MESSAGE(
                    role: .tool,
                    name: response.toolName,
                    toolCallID: response.id,
                    content: response.toolResponse)
            )
        }

        self.lastModel = model
        return try await send(model: model)
    }

    func retry() async throws -> AIResponse {
        guard let model = self.lastModel else {
            throw RetryError.noPreviousRequest
        }

        return try await send(model: model, isRetry: true)
    }

    private func send(model: String,
                      isRetry: Bool = false) async throws -> AIResponse {
        let dto = REQUEST(
            model: model,
            messages: messages,
            tools: tools?.map { CommonTool(tool: $0) }
        )
        logger.d("\(isRetry ? "retrying" : "sending"): \(dto.json ?? "nil")")
        let response = await WebResponse<RESPONSE>
            .withTimeout(config.maxThinkingTimeInSecods)
            .post(url: config.modelUrl.trimming("/") + config.provider.promptPath,
                  body: dto, headers: headers)
        switch response {
        case .failure(let httpError):
            if case .unserializablaResponse(let data) = httpError, let data {
                logger.e("unserializable response: \(String(data: data, encoding: .utf8) ?? "nil")")
            }
            throw httpError
        case .response(let body, _):
            usedTokens += body.usedTokens
            logger.d("response: \(body.json ?? "nil")")
            if let lastMessage = body.lastMessage {
                messages.append(lastMessage)
                if lastMessage.calls.isEmpty.not {
                    return respond(.toolCall(lastMessage.calls, reasoning: lastMessage.thinkingText), with: body)
                }
                return respond(.text(lastMessage.content ?? "No answer"), with: body)
            }
            return respond(.text("No message"), with: body)
        }
    }

    private func respond(_ response: SessionResponse, with body: RESPONSE) -> AIResponse {
        AIResponse(
            sessionReponse: response,
            inputTokens: body.inputTokens,
            outputTokens: body.outputTokens)
    }
}
