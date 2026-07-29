//
//  ToolResult.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//

struct ToolResult: Codable {
    let content: [Content]
    struct Content: Codable {
        let type: String
        let text: String
    }
}
