//
//  AgentConfig.swift
//  SwiftAgent
//
//  Created by: tomieq on 28/07/2026
//

public struct AgentConfig {
    let provider: ModelProvider
    let modelUrl: String
    let authToken: String?

    public init(provider: ModelProvider, modelUrl: String, authToken: String? = nil) {
        self.provider = provider
        self.modelUrl = modelUrl
        self.authToken = authToken
    }
}
