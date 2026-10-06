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

    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case tools
    }
}

extension OpenAIRequestDto: ModelRequest {
    init(model: String, messages: [any ModelMessage], tools: [CommonTool]?) {
        self.model = model
        self.messages = messages.compactMap{ $0 as? OpenAIMessageDto }
        self.tools = tools
    }
}
