import WebResponse
import SwiftExtensions

public final class SwiftAgent {
    private let config: AgentConfig
    private let tools: [Tool]?

    public init(config: AgentConfig, tools: [Tool]? = nil) {
        self.config = config
        self.tools = tools
    }

    public func session(systemMessage: String? = nil) -> AISession {
        switch config.provider {
        case .ollama:
            SessionExecutor<OllamaRequestDto, OllamaResponseDto, OllamaMessageDto>(config: config, tools: tools, systemMessage: systemMessage)
        case .openAI:
            SessionExecutor<OpenAIRequestDto, OpenAIResponseDto, OpenAIMessageDto>(config: config, tools: tools, systemMessage: systemMessage)
        }
    }
}
