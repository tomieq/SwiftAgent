//
//  OllamaResponseDto.swift
//  SwiftAgent
//
//  Created by: tomieq on 28/07/2026
//

struct OllamaResponseDto: Codable {
    let message: OllamaMessageDto
    let model: String
    let promptTokens: Int
    let completionTokens: Int

    enum CodingKeys: String, CodingKey {
        case message
        case model
        case promptTokens = "prompt_eval_count"
        case completionTokens = "eval_count"
    }
}

extension OllamaResponseDto: ModelResponse {
    var lastMessage: ModelMessage? {
        self.message
    }

    var usedTokens: Int {
        promptTokens + completionTokens
    }
}
