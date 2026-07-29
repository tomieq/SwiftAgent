//
//  CommonMessageDto.swift
//  SwiftAgent
//
//  Created by: tomieq on 28/07/2026
//

struct OpenAIMessageDto: Codable {
    let role: RoleDto
    let content: String?
    let toolCalls: [OpenAIToolCall]?
    let reasoning: String?
    let thinking: String?

    enum CodingKeys: String, CodingKey {
        case role, content
        case toolCalls = "tool_calls"
        case reasoning, thinking
    }
}

struct OpenAIToolCall: Codable {
    let function: OpenAIToolFunction
    let id: String
}

struct OpenAIToolFunction: Codable {
    let name: String
    let arguments: String
}
