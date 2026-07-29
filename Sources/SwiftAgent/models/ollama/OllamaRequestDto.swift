//
//  OllamaRequestDto.swift
//  SwiftAgent
//
//  Created by: tomieq on 28/07/2026
//

struct OllamaRequestDto: Codable {
    let model: String
    let messages: [OllamaMessageDto]
    let tools: [CommonTool]
    let stream: Bool
}
