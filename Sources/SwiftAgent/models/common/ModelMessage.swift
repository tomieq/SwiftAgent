//
//  ModelMessage.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//

protocol ModelMessage {
    init(role: RoleDto, name: String?, toolCallID: String?, content: String)
    var content: String? { get }
    var toolCall: ToolCall? { get }
}
