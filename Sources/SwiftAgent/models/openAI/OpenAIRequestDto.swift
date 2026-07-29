//
//  OpenAIRequestDto.swift
//  SwiftAgent
//
//  Created by: tomieq on 28/07/2026
//

struct OpenAIRequestDto: Codable {
    let model: String
    let messages: [OpenAIMessageDto]
    let tools: [CommonTool]
}
