//
//  ModelProvider.swift
//  SwiftAgent
//
//  Created by: tomieq on 28/07/2026
//

public enum ModelProvider {
    case ollama
    case openAI // all OpenAI compatible protocols (vllm)
}

extension ModelProvider {
    var promptPath: String {
        switch self {
        case .ollama:
            return "/api/chat"
        case .openAI:
            return "/chat/completions"
        }
    }

    var modelsPath: String {
        switch self {
        case .ollama:
            return "/api/tags"
        case .openAI:
            return "/models"
        }
    }
}
