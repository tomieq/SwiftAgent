//
//  CommonMessageDto.swift
//  SwiftAgent
//
//  Created by: tomieq on 28/07/2026
//

struct OpenAIMessageDto: Codable {
    let role: RoleDto
    let name: String?
    let content: String?
    let toolCalls: [OpenAIToolCall]?
    let reasoning: String?
    let thinking: String?

    init(role: RoleDto,
         name: String? = nil,
         content: String?,
         toolCalls: [OpenAIToolCall]? = nil,
         reasoning: String? = nil,
         thinking: String? = nil) {
        self.role = role
        self.name = name
        self.content = content
        self.toolCalls = toolCalls
        self.reasoning = reasoning
        self.thinking = thinking
    }

    enum CodingKeys: String, CodingKey {
        case role, name, content
        case toolCalls = "tool_calls"
        case reasoning, thinking
    }
}

struct OpenAIToolCall: Codable {
    let type = "function"
    let function: OpenAIToolFunction
    let id: String
}

struct OpenAIToolFunction: Codable {
    let name: String
    // arguments contains a json String in format name: value
    let arguments: String
}
