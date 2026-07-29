import WebResponse
import SwiftExtensions

public final class SwiftAgent {
    private let config: AgentConfig
    private let tools: [Tool]

    public init(config: AgentConfig, tools: [Tool] = []) {
        self.config = config
        self.tools = tools
    }

    public func ask(_ prompt: String, model: String) async throws -> String {
        switch config.provider {
        case .ollama:
            try await askOllama(prompt, model: model)
        case .openAI:
            try await askVllm(prompt, model: model)
        }
    }

    func askVllm(_ prompt: String, model: String) async throws -> String {
        let dto = OpenAIRequestDto(
            model: model,
            messages: [
                OpenAIMessageDto(
                    role: .user,
                    content: prompt,
                    toolCalls: nil,
                    reasoning: nil,
                    thinking: nil)
            ],
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
            return body.choices.first?.message.content ?? "No answer"
        }
    }

    func askOllama(_ prompt: String, model: String) async throws -> String {
        let dto = OllamaRequestDto(
            model: model,
            messages: [
                OllamaMessageDto(
                    role: .user,
                    content: prompt,
                    toolCalls: nil,
                    reasoning: nil,
                    thinking: nil)
            ],
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
            return body.message.content ?? "nil"
        }
    }
}
