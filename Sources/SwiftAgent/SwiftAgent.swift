import WebResponse
import SwiftExtensions

public final class SwiftAgent {
    private let config: AgentConfig
    private let tools: [Tool]

    private var ollamaMessages: [OllamaMessageDto] = []
    private var openAIMessages: [OpenAIMessageDto] = []

    public init(config: AgentConfig, tools: [Tool] = []) {
        self.config = config
        self.tools = tools
    }

    public func ask(_ prompt: String, model: String) async throws -> String {
        switch config.provider {
        case .ollama:
            try await askOllama(prompt, model: model)
        case .openAI:
            try await askOpenAI(prompt, model: model)
        }
    }

    public func toolResponse(_ toolResponse: String, toolName: String, model: String) async throws -> String {
        switch config.provider {
        case .ollama:
            try await toolOllama(toolResponse, toolName: toolName, model: model)
        case .openAI:
            try await toolOpenAI(toolResponse, toolName: toolName, model: model)
        }
    }

    func askOpenAI(_ prompt: String, model: String) async throws -> String {
        openAIMessages.append(
            OpenAIMessageDto(
                role: .user,
                content: prompt)
        )
        let dto = OpenAIRequestDto(
            model: model,
            messages: openAIMessages,
            tools: tools.map{ CommonTool(tool: $0) }
        )
        print("sending: \(dto.json ?? "nil")")
        let response = await WebResponse<OpenAIResponseDto>
            .withTimeout(60)
            .post(url: config.modelUrl.trimming("/") + "/chat/completions",
                  body: dto)
        switch response {
        case .failure(let httpError):
            if case .unserializablaResponse(let data) = httpError, let data {
                print(String(data: data, encoding: .utf8) ?? "nil")
            }
            throw httpError
        case .response(let body, _):
            print(body.json ?? "nil")
            openAIMessages.append(contentsOf: body.choices.map { $0.message })
            return body.choices.first?.message.content ?? "No answer"
        }
    }

    func toolOpenAI(_ toolResponse: String, toolName: String, model: String) async throws -> String {
        openAIMessages.append(
            OpenAIMessageDto(
                role: .user,
                name: toolName,
                content: toolResponse)
        )
        let dto = OpenAIRequestDto(
            model: model,
            messages: openAIMessages,
            tools: tools.map{ CommonTool(tool: $0) }
        )
        let response = await WebResponse<OpenAIResponseDto>
            .withTimeout(60)
            .post(url: config.modelUrl.trimming("/") + "/chat/completions",
                  body: dto)
        switch response {
        case .failure(let httpError):
            if case .unserializablaResponse(let data) = httpError, let data {
                print(String(data: data, encoding: .utf8) ?? "nil")
            }
            throw httpError
        case .response(let body, _):
            print(body.json ?? "nil")
            openAIMessages.append(contentsOf: body.choices.map { $0.message })
            return body.choices.first?.message.content ?? "No answer"
        }
    }

    func askOllama(_ prompt: String, model: String) async throws -> String {
        ollamaMessages.append(
            OllamaMessageDto(
                role: .user,
                content: prompt)
        )

        let dto = OllamaRequestDto(
            model: model,
            messages: ollamaMessages,
            tools: tools.map{ CommonTool(tool: $0) },
            stream: false)
        print("sending: \(dto.json ?? "nil")")
        let response = await WebResponse<OllamaResponseDto>
            .withTimeout(60)
            .post(url: config.modelUrl.trimming("/") + "/api/chat",
                  body: dto)
        switch response {
        case .failure(let httpError):
            if case .unserializablaResponse(let data) = httpError, let data {
                print(String(data: data, encoding: .utf8) ?? "nil")
            }
            throw httpError
        case .response(let body, _):
            print(body.json ?? "nil")
            ollamaMessages.append(body.message)
            return body.message.content ?? "nil"
        }
    }

    func toolOllama(_ toolResponse: String, toolName: String, model: String) async throws -> String {
        ollamaMessages.append(
            OllamaMessageDto(
                role: .tool,
                name: toolName,
                content: toolResponse)
        )

        let dto = OllamaRequestDto(
            model: model,
            messages: ollamaMessages,
            tools: tools.map{ CommonTool(tool: $0) },
            stream: false)
        print("sending: \(dto.json ?? "nil")")
        let response = await WebResponse<OllamaResponseDto>
            .withTimeout(60)
            .post(url: config.modelUrl.trimming("/") + "/api/chat",
                  body: dto)
        switch response {
        case .failure(let httpError):
            if case .unserializablaResponse(let data) = httpError, let data {
                print(String(data: data, encoding: .utf8) ?? "nil")
            }
            throw httpError
        case .response(let body, _):
            print(body.json ?? "nil")
            ollamaMessages.append(body.message)
            return body.message.content ?? "nil"
        }
    }
}
