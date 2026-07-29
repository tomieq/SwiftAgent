//
//  OllamaRequestDto.swift
//  SwiftAgent
//
//  Created by: tomieq on 28/07/2026
//

struct OllamaRequestDto: Codable {
    let model: String
    let messages: [OllamaMessageDto]
    let tools: [CommonTool]?
    let stream: Bool
}

extension OllamaRequestDto: ModelRequest {
    init(model: String, messages: [any ModelMessage], tools: [CommonTool]?) {
        self.model = model
        self.messages = messages.compactMap{ $0 as? OllamaMessageDto }
        self.tools = tools
        self.stream = false
    }
}
