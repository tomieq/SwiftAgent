//
//  AISession.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//

public protocol AISession {
    func ask(_ prompt: String, model: String) async throws -> AIResponse
    func toolResponse(_ responses: [ToolResponse], model: String) async throws -> AIResponse
    func retry() async throws -> AIResponse
    var usedTokens: Int { get }
}

public extension AISession {
    func ask(_ prompt: String, model: String) async throws -> AIResponse {
        try await ask(prompt, model: model)
    }

    func toolResponse(_ responses: [ToolResponse], model: String) async throws -> AIResponse {
        try await toolResponse(responses, model: model)
    }
}
