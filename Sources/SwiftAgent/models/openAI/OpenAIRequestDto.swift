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
}

extension OpenAIRequestDto: ModelRequest {
    init(model: String, messages: [any ModelMessage], tools: [CommonTool]?) {
        self.model = model
        self.messages = messages.compactMap{ $0 as? OpenAIMessageDto }
        self.tools = tools
    }
}
