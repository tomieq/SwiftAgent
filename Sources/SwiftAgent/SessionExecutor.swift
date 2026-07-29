//
//  SessionExecutor.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//
import WebResponse

final class SessionExecutor<REQUEST: ModelRequest, RESPONSE: ModelResponse, MESSAGE: ModelMessage>: AISession {
    private var messages: [ModelMessage] = []
    let config: AgentConfig
    let tools: [Tool]?

    init(config: AgentConfig, tools: [Tool]?) {
        self.config = config
        self.tools = tools
    }

    func ask(_ prompt: String, model: String) async throws -> SessionResponse {
        messages.append(
            MESSAGE(
                role: .user,
                name: nil,
                content: prompt)
        )
        let dto = REQUEST(
            model: model,
            messages: messages,
            tools: tools?.map{ CommonTool(tool: $0) }
        )
        print("sending: \(dto.json ?? "nil")")
        let response = await WebResponse<RESPONSE>
            .withTimeout(60)
            .post(url: config.modelUrl.trimming("/") + config.provider.path,
                  body: dto)
        switch response {
        case .failure(let httpError):
            if case .unserializablaResponse(let data) = httpError, let data {
                print(String(data: data, encoding: .utf8) ?? "nil")
            }
            throw httpError
        case .response(let body, _):
            print("response: \(body.json ?? "nil")")
            if let lastMessage = body.lastMessage {
                messages.append(lastMessage)
                if let functionCall = lastMessage.functionCall {
                    return .functionCall(functionCall)
                }
                return .text(lastMessage.content ?? "No answer")
            }
            return .text("No message")
        }
    }

    func toolResponse(_ toolResponse: String, toolName: String, model: String) async throws -> SessionResponse {
        messages.append(
            MESSAGE(
                role: .tool,
                name: toolName,
                content: toolResponse)
        )

        let dto = REQUEST(
            model: model,
            messages: messages,
            tools: tools?.map{ CommonTool(tool: $0) }
        )
        print("sending: \(dto.json ?? "nil")")
        let response = await WebResponse<RESPONSE>
            .withTimeout(60)
            .post(url: config.modelUrl.trimming("/") + config.provider.path,
                  body: dto)
        switch response {
        case .failure(let httpError):
            if case .unserializablaResponse(let data) = httpError, let data {
                print(String(data: data, encoding: .utf8) ?? "nil")
            }
            throw httpError
        case .response(let body, _):
            print("response: \(body.json ?? "nil")")
            if let lastMessage = body.lastMessage {
                messages.append(lastMessage)
                if let functionCall = lastMessage.functionCall {
                    return .functionCall(functionCall)
                }
                return .text(lastMessage.content ?? "No answer")
            }
            return .text("No message")
        }
    }
}
