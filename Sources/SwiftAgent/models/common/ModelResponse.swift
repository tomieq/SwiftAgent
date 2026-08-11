//
//  ModelResponse.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//

protocol ModelResponse: Codable {
    var lastMessage: ModelMessage? { get }
    var usedTokens: Int { get }
    var inputTokens: Int { get }
    var outputTokens: Int { get }
}
