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

extension OpenAIMessageDto: ModelMessage {
    init(role: RoleDto, name: String?, content: String) {
        self.init(role: role,
                  name: name,
                  content: content,
                  toolCalls: nil)
    }

    var functionCall: FunctionCall? {
        guard let firstCall = toolCalls?.first?.function else {
            return nil
        }

        guard let arguments: [String: JSONValue] = .init(json: firstCall.arguments) else {
            print("Problem creating [String: JSONValue] from: \(firstCall.arguments)")
            return nil
        }
        return FunctionCall(name: firstCall.name, arguments: arguments)
    }
}
