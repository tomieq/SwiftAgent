//
//  OpenAIResponseDto.swift
//  SwiftAgent
//
//  Created by: tomieq on 28/07/2026
//

struct OpenAIResponseDto: Codable {
    let choices: [OpenAIChoiceDto]
    let model: String
    let usage: OpenAIUsageDto
}

extension OpenAIResponseDto: ModelResponse {
    var lastMessage: ModelMessage? {
        self.choices.first?.message
    }

    var usedTokens: Int {
        usage.totalTokens
    }
}

struct OpenAIChoiceDto: Codable {
    let message: OpenAIMessageDto
    let finishReason: OpenAIFinishReason?
    let stopReason: String?

    enum CodingKeys: String, CodingKey {
        case message
        case finishReason = "finish_reason"
        case stopReason = "stop_reason"
    }
}

enum OpenAIFinishReason: String, Codable {
    case toolCalls = "tool_calls"
    case stop
}
