//
//  CommonTool.swift
//  SwiftAgent
//
//  Created by: tomieq on 28/07/2026
//

struct CommonTool: Codable {
    let type = "function"
    let function: Function

    struct Function: Codable {
        let name: String
        let description: String?
        let parameters: JSONSchema
    }
}

extension CommonTool {
    init(tool: Tool) {
        function = .init(
            name: tool.name,
            description: tool.description,
            parameters: tool.inputSchema
        )
    }
}
