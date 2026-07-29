//
//  MCPAdapter.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//
import WebResponse
import SwiftAgent

public final class MCPAdapter {
    public init() {}

    public func getTools() async -> [Tool] {
        var tools: [Tool] = []
        let command = Command(id: 1, method: "tools/list", params: nil)
        let response = await WebResponse<MCPResponse<ToolsList>>
            .withTimeout(20)
            .post(url: "http://localhost:8080/mcp", body: command)
        switch response {
        case .failure(let httpError):
            print("Error: \(httpError)")
        case .response(let dto, _):
            for schema in dto.result.tools {
                let tool = Tool(
                    name: schema.name,
                    description: schema.description,
                    inputSchema: schema.inputSchema)
                tools.append(tool)
            }
        }
        return tools
    }

    public func call(function: FunctionCall) async -> String {
        let command = Command(id: 1,
                              method: "tools/call",
                              params: .init(protocolVersion: "1.0",
                                            name: function.name,
                                            arguments: function.arguments))
        let response = await WebResponse<MCPResponse<ToolResult>>
            .withTimeout(20)
            .post(url: "http://localhost:8080/mcp", body: command)
        switch response {
        case .failure(let httpError):
            return "Error: \(httpError)"
        case .response(let dto, _):
            return dto.result.content.map{ $0.text }.jsonOneLine ?? "No data"
        }
    }
}
