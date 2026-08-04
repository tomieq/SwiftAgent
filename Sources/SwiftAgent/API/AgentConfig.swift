//
//  AgentConfig.swift
//  SwiftAgent
//
//  Created by: tomieq on 28/07/2026
//

public struct AgentConfig {
    public let name: String
    public let preferredModel: String?
    let provider: ModelProvider
    let modelUrl: String
    let authToken: String?

    public init(name: String,
                provider: ModelProvider,
                modelUrl: String,
                authToken: String? = nil,
                preferredModel: String? = nil) {
        self.name = name
        self.provider = provider
        self.modelUrl = modelUrl
        self.authToken = authToken
        self.preferredModel = preferredModel
    }
}

extension AgentConfig {
    public func models() async -> [String] {
        switch self.provider {
        case .ollama:
            await ModelFetcher<OllamaModelList>().fetch(self)
        case .openAI:
            await ModelFetcher<OpenAIModelList>().fetch(self)
        }
    }
}
