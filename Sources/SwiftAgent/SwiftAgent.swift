import WebResponse
import SwiftExtensions

public final class SwiftAgent {
    let proxy: AIProxy
    private let config: AgentConfig
    private let tools: [Tool]?

    private var ollamaMessages: [OllamaMessageDto] = []
    private var openAIMessages: [OpenAIMessageDto] = []

    public init(config: AgentConfig, tools: [Tool]? = nil) {
        switch config.provider {
        case .ollama:
            self.proxy = ModelProxy<OllamaRequestDto, OllamaResponseDto, OllamaMessageDto>(config: config, tools: tools)
        case .openAI:
            self.proxy = ModelProxy<OpenAIRequestDto, OpenAIResponseDto, OpenAIMessageDto>(config: config, tools: tools)
        }
        self.config = config
        self.tools = tools
    }

    public func ask(_ prompt: String, model: String) async throws -> String {
        try await proxy.ask(prompt, model: model)
    }

    public func toolResponse(_ toolResponse: String, toolName: String, model: String) async throws -> String {
        try await proxy.toolResponse(toolResponse, toolName: toolName, model: model)
    }
}
