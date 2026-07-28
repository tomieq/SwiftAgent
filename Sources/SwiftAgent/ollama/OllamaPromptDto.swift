//
//  OllamaPromptDto.swift
//  SwiftAgent
// 
//  Created by: tomieq on 28/07/2026
//

struct OllamaPromptDto: Codable {
    let model: String
    let prompt: String
    let stream: Bool
}
