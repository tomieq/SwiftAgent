//
//  ToolsList.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//

import SwiftAgent

struct ToolsList: Codable {
    let tools: [Schema]

    struct Schema: Codable {
        let name: String
        let description: String
        let inputSchema: JSONSchema
        let outputSchema: JSONSchema?
    }
}
