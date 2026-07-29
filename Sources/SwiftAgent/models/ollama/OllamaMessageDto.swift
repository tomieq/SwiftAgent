//
//  OllamaMessageDto.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//

struct OllamaMessageDto: Codable {
    let role: RoleDto
    let content: String?
    let toolCalls: [OllamaToolCall]?
    let reasoning: String?
    let thinking: String?

    enum CodingKeys: String, CodingKey {
        case role, content
        case toolCalls = "tool_calls"
        case reasoning, thinking
    }
}

struct OllamaToolCall: Codable {
    let function: OllamaToolFunction
    let id: String
}

struct OllamaToolFunction: Codable {
    let name: String
    // Ollama returns structured JSON, whose values can be numbers, booleans,
    // arrays, objects, or null as well as strings.
    let arguments: [String: JSONValue]
}
