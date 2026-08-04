//
//  ToolResult.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//
import SwiftAgent

struct ToolResult: Codable {
    let content: [Content]
    let structuredContent: JSONValue?
    struct Content: Codable {
        let type: String
        let text: String
    }
}
