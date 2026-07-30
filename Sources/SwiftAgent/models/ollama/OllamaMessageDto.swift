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
    let toolCallID: String?

    init(role: RoleDto,
         name: String? = nil,
         content: String?,
         toolCalls: [OllamaToolCall]? = nil,
         reasoning: String? = nil,
         thinking: String? = nil,
         toolCallID: String? = nil) {
        self.role = role
        self.name = name
        self.content = content
        self.toolCalls = toolCalls
        self.reasoning = reasoning
        self.thinking = thinking
        self.toolCallID = toolCallID
    }

    enum CodingKeys: String, CodingKey {
        case role, name, content
        case toolCalls = "tool_calls"
        case reasoning, thinking
        case toolCallID = "tool_call_id"
    }
}

extension OllamaMessageDto: ModelMessage {
    init(role: RoleDto, name: String?, toolCallID: String?, content: String) {
        self.init(role: role,
                  name: name,
                  content: content,
                  toolCalls: nil,
                  toolCallID: toolCallID
        )
    }

    var calls: [ToolCall] {
        self.toolCalls?.map { call in
            ToolCall(id: call.id,
                     function: FunctionCall(name: call.function.name,
                                            arguments: call.function.arguments))
        } ?? []
    }
}
