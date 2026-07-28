//
//  VllmPromptDto.swift
//  SwiftAgent
// 
//  Created by: tomieq on 28/07/2026
//

struct VllmPromptDto: Codable {
    let model: String
    let messages: [VllmPromptMessage]
}
