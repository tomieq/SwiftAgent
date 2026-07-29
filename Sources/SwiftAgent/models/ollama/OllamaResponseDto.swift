//
//  OllamaResponseDto.swift
//  SwiftAgent
//
//  Created by: tomieq on 28/07/2026
//

struct OllamaResponseDto: Codable {
    let message: OllamaMessageDto
    let model: String
}

extension OllamaResponseDto: ModelResponse {
    var lastMessage: ModelMessage? {
        self.message
    }
}
