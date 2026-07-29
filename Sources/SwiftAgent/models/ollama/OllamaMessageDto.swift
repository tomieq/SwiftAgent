//
//  OllamaMessageDto.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//

struct OllamaMessageDto: Codable {
    let role: RoleDto
    let name: String?
    let content: String?
    let toolCalls: [OllamaToolCall]?
    let reasoning: String?
    let thinking: String?

    init(role: RoleDto,
         name: String? = nil,
         content: String?,
         toolCalls: [OllamaToolCall]? = nil,
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

extension OllamaMessageDto: ModelMessage {
    init(role: RoleDto, name: String?, content: String) {
        self.init(role: role,
                  name: name,
                  content: content,
                  toolCalls: nil)
    }
}

struct OllamaToolCall: Codable {
    let type = "function"
    let function: OllamaToolFunction
    let id: String
}

struct OllamaToolFunction: Codable {
    let name: String
    // Ollama returns structured JSON, whose values can be numbers, booleans,
    // arrays, objects, or null as well as strings.
    let arguments: [String: JSONValue]
}
