import WebResponse

public final class SwiftAgent {
    private let config: AgentConfig
    
    public init(config: AgentConfig) {
        self.config = config
    }

    public func ask(_ prompt: String, model: String) async throws -> String {
        let dto = PromptDto(
            model: model,
            prompt: prompt,
            stream: false)
        let response = await WebResponse<PromptResponseDto>
            .withTimeout(60)
            .post(url: config.modelUrl,
                  body: dto)
        switch response {
        case .failure(let httpError):
            throw httpError
        case .response(let body, let headers):
            return body.response
        }
    }
}
