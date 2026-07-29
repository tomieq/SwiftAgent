//
//  OpenAIUsageDto.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//

struct OpenAIUsageDto: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}