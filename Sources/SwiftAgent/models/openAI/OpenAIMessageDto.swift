//
//  CommonMessageDto.swift
//  SwiftAgent
//
//  Created by: tomieq on 28/07/2026
//
import Logger

struct OpenAIMessageDto: Codable {
    let role: RoleDto
    let name: String?
    let toolCallID: String?
    let content: String?
    let toolCalls: [OpenAIToolCall]?
    let reasoning: String?
    let thinking: String?

    init(role: RoleDto,
         name: String? = nil,
         content: String?,
         toolCalls: [OpenAIToolCall]? = nil,
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

extension OpenAIMessageDto: ModelMessage {
    init(role: RoleDto, name: String?, toolCallID: String?, content: String) {
        self.init(role: role,
                  name: name,
                  content: content,
                  toolCalls: nil,
                  toolCallID: toolCallID)
    }

    var calls: [ToolCall] {
        toolCalls?.compactMap { call in
            guard let arguments: [String: JSONValue] = .init(json: call.function.arguments) else {
                Logger("OpenAIMessageDto").e("Problem creating [String: JSONValue] from: \(call.function.arguments)")
                return nil
            }
            return ToolCall(id: call.id,
                            function: FunctionCall(name: call.function.name,
                                                   arguments: arguments))
        } ?? []
    }
}
