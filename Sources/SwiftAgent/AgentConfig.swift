//
//  AgentConfig.swift
//  SwiftAgent
// 
//  Created by: tomieq on 28/07/2026
//

public struct AgentConfig {
    let provider: ModelProvider
    let modelUrl: String
    
    public init (provider: ModelProvider, modelUrl: String) {
        self.provider = provider
        self.modelUrl = modelUrl
    }
}

