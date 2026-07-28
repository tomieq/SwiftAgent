import WebResponse
import SwiftExtensions

public final class SwiftAgent {
    private let config: AgentConfig
    
    public init(config: AgentConfig) {
        self.config = config
    }

    public func ask(_ prompt: String, model: String) async throws -> String {
        switch config.provider {
        case .ollama:
            try await askOllama(prompt, model: model)
        case .vllm:
            try await askVllm(prompt, model: model)
        }
    }
    func askVllm(_ prompt: String, model: String) async throws -> String {
        let dto = VllmPromptDto(
            model: model,
            messages: [
                VllmPromptMessage(role: .user, content: prompt)
            ])
        let response = await WebResponse<VllmPromptResponse>
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
        let dto = OllamaPromptDto(
            model: model,
            prompt: prompt,
            stream: false)
        let response = await WebResponse<OllamaPromptResponseDto>
            .withTimeout(60)
            .post(url: config.modelUrl.trimming("/") + "/api/generate",
                  body: dto)
        switch response {
        case .failure(let httpError):
            if case .unserializablaResponse(let data) = httpError, let data {
                print(String(data: data, encoding: .utf8) ?? "nil")
            }
            throw httpError
        case .response(let body, _):
            print(body.json ?? "nil")
            return body.response
        }
    }
}
