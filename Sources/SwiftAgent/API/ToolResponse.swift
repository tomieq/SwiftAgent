//
//  ToolResponse.swift
//  SwiftAgent
//
//  Created by: tomieq on 30/07/2026
//

public struct ToolResponse {
    let id: String
    let toolName: String
    let toolResponse: String

    public init(id: String, toolName: String, toolResponse: String) {
        self.id = id
        self.toolName = toolName
        self.toolResponse = toolResponse
    }
}
