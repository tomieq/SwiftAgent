//
//  SessionExecutor.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//
import WebResponse
import Logger

final class SessionExecutor<REQUEST: ModelRequest, RESPONSE: ModelResponse, MESSAGE: ModelMessage>: AISession {
    private var messages: [ModelMessage] = []
    private let logger = Logger("AISession")
    let config: AgentConfig
    let tools: [Tool]?
    let headers: [String: String]
    var usedTokens: Int = 0

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

    func ask(_ prompt: String, model: String) async throws -> SessionResponse {
        messages.append(
            MESSAGE(
                role: .user,
                name: nil,
                toolCallID: nil,
                content: prompt)
        )
        let dto = REQUEST(
            model: model,
            messages: messages,
            tools: tools?.map{ CommonTool(tool: $0) }
        )
        logger.d("sending: \(dto.json ?? "nil")")
        let response = await WebResponse<RESPONSE>
            .withTimeout(60)
            .post(url: config.modelUrl.trimming("/") + config.provider.path,
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
                    return .toolCall(lastMessage.calls)
                }
                return .text(lastMessage.content ?? "No answer")
            }
            return .text("No message")
        }
    }

    func toolResponse(_ responses: [ToolResponse], model: String) async throws -> SessionResponse {
        for response in responses {
            messages.append(
                MESSAGE(
                    role: .tool,
                    name: response.toolName,
                    toolCallID: response.id,
                    content: response.toolResponse)
            )
        }

        let dto = REQUEST(
            model: model,
            messages: messages,
            tools: tools?.map{ CommonTool(tool: $0) }
        )
        logger.d("sending: \(dto.json ?? "nil")")
        let response = await WebResponse<RESPONSE>
            .withTimeout(60)
            .post(url: config.modelUrl.trimming("/") + config.provider.path,
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
                    return .toolCall(lastMessage.calls)
                }
                return .text(lastMessage.content ?? "No answer")
            }
            return .text("No message")
        }
    }
}
