//
//  AISession.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//

public protocol AISession {
    func ask(_ prompt: String, model: String) async throws -> SessionResponse
    func toolResponse(_ responses: [ToolResponse], model: String) async throws -> SessionResponse
    var usedTokens: Int { get }
}
