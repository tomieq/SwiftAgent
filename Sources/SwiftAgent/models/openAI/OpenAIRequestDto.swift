//
//  OpenAIRequestDto.swift
//  SwiftAgent
//
//  Created by: tomieq on 28/07/2026
//

struct OpenAIRequestDto: Codable {
    let model: String
    let messages: [OpenAIMessageDto]
    let tools: [CommonTool]?
    let reasoningEffort: ReasoningEffort?

    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case tools
        case reasoningEffort = "reasoning_effort"
    }
}

extension OpenAIRequestDto: ModelRequest {
    init(model: String, messages: [any ModelMessage], tools: [CommonTool]?, reasoningEffort: ReasoningEffort?) {
        self.model = model
        self.messages = messages.compactMap{ $0 as? OpenAIMessageDto }
        self.tools = tools
        self.reasoningEffort = reasoningEffort
    }
}
