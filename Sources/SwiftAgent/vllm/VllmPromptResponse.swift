//
//  VllmPromptResponse.swift
//  SwiftAgent
// 
//  Created by: tomieq on 28/07/2026
//


struct VllmPromptResponse: Codable {
    let choices: [VllmChoiceResponse]
    let model: String
}

struct VllmChoiceResponse: Codable {
    let message: VllmPromptMessage
}
