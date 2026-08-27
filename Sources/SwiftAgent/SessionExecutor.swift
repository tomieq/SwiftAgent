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
    private var lastRequest: (model: String, reasoningEffort: ReasoningEffort?)?

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

    func ask(_ prompt: String, model: String, reasoningEffort: ReasoningEffort?) async throws -> AIResponse {
        messages.append(
            MESSAGE(
                role: .user,
                name: nil,
                toolCallID: nil,
                content: prompt)
        )
        let request = (model, reasoningEffort)
        lastRequest = request
        return try await send(request)
    }

    func toolResponse(_ responses: [ToolResponse], model: String, reasoningEffort: ReasoningEffort?) async throws -> AIResponse {
        for response in responses {
            messages.append(
                MESSAGE(
                    role: .tool,
                    name: response.toolName,
                    toolCallID: response.id,
                    content: response.toolResponse)
            )
        }

        let request = (model, reasoningEffort)
        lastRequest = request
        return try await send(request)
    }

    func retry() async throws -> AIResponse {
        guard let lastRequest else {
            throw RetryError.noPreviousRequest
        }

        return try await send(lastRequest, isRetry: true)
    }

    private func send(_ request: (model: String, reasoningEffort: ReasoningEffort?),
                      isRetry: Bool = false) async throws -> AIResponse {
        let dto = REQUEST(
            model: request.model,
            messages: messages,
            tools: tools?.map { CommonTool(tool: $0) },
            reasoningEffort: request.reasoningEffort
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
                    return respond(.toolCall(lastMessage.calls), with: body)
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
