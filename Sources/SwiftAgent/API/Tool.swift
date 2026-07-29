//
//  Tool.swift
//  SwiftAgent
//
//  Created by: tomieq on 28/07/2026
//

public struct Tool: Codable {
    public let name: String
    public let description: String?
    public let inputSchema: JSONSchema

    public init(name: String, description: String?, inputSchema: JSONSchema) {
        self.name = name
        self.description = description
        self.inputSchema = inputSchema
    }
}


