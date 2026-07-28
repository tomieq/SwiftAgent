//
//  VllmPromptMessage.swift
//  SwiftAgent
// 
//  Created by: tomieq on 28/07/2026
//


struct VllmPromptMessage: Codable {
    let role: VllmPromptRole
    let content: String
}

enum VllmPromptRole: String, Codable {
    case user
    case assistant
}
