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
    let think: String?
}

extension OllamaRequestDto: ModelRequest {
    init(model: String, messages: [any ModelMessage], tools: [CommonTool]?, reasoningEffort: ReasoningEffort?) {
        self.model = model
        self.messages = messages.compactMap{ $0 as? OllamaMessageDto }
        self.tools = tools
        self.stream = false
        self.think = switch reasoningEffort {
        case .xhigh:
            "max"
        case .low, .medium, .high:
            reasoningEffort?.rawValue
        case nil:
            nil
        }
    }
}
