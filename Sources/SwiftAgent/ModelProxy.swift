//
//  ModelProxy.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//
import WebResponse

protocol AIProxy {
    func ask(_ prompt: String, model: String) async throws -> String
    func toolResponse(_ toolResponse: String, toolName: String, model: String) async throws -> String
}

final class ModelProxy<REQUEST: ModelRequest, RESPONSE: ModelResponse, MESSAGE: ModelMessage>: AIProxy {
    private var messages: [ModelMessage] = []
    let config: AgentConfig
    let tools: [Tool]?

    init(config: AgentConfig, tools: [Tool]?) {
        self.config = config
        self.tools = tools
    }

    func ask(_ prompt: String, model: String) async throws -> String {
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
            print(body.json ?? "nil")
            if let lastMessage = body.lastMessage {
                messages.append(lastMessage)
                return lastMessage.content ?? "No answer"
            }
            return "No answer"
        }
    }

    func toolResponse(_ toolResponse: String, toolName: String, model: String) async throws -> String {
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
            print(body.json ?? "nil")
            if let lastMessage = body.lastMessage {
                messages.append(lastMessage)
                return lastMessage.content ?? "No answer"
            }
            return "No answer"
        }
    }
}
