//
//  MCPAdapter.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//
import WebResponse
import SwiftAgent
import SwiftExtensions
import Logger

public final class MCPAdapter {
    let mcpData: [String: MCPData]
    let logger = Logger(MCPAdapter.self)
    static let separator = "_"

    public init(configs: [MCPConfig]) {
        var mcpData: [String: MCPData] = [:]
        var index = 0
        configs.forEach {
            index.increment()
            let id = "\($0.name.removed(text: Self.separator))\(index)"
            mcpData[id] = MCPData(id: id, config: $0)
        }
        self.mcpData = mcpData
    }

    public func getTools() async -> [Tool] {
        var tools: [Tool] = []
        for (_, mcpData) in mcpData {
            let toolsFromMCP = await getTools(mcpData: mcpData)
            tools.append(contentsOf: toolsFromMCP)
            logger.i("Available tools for \(mcpData.id): \(tools.map{ $0.name }.joined(separator: ", "))")
        }
        return tools
    }

    func getTools(mcpData: MCPData) async -> [Tool] {
        var tools: [Tool] = []
        let command = Command(id: 1, method: "tools/list", params: nil)
        let response = await WebResponse<MCPResponse<ToolsList>>
            .withTimeout(20)
            .post(url: mcpData.config.url, body: command)
        switch response {
        case .failure(let httpError):
            print("Error: \(httpError)")
        case .response(let dto, _):
            for schema in dto.result.tools {
                let tool = Tool(
                    name: "\(mcpData.id)\(Self.separator)\(schema.name)",
                    description: schema.description,
                    inputSchema: schema.inputSchema)
                tools.append(tool)
            }
        }
        return tools
    }

    public func call(function: FunctionCall) async -> String {
        guard let mcpID = function.name.split(Self.separator).first, let data = mcpData[mcpID] else {
            logger.e("Invalid tool name \(function.name)")
            return "Invalid tool name"
        }
        logger.i("Calling \(function.name)")
        let command = Command(id: 1,
                              method: "tools/call",
                              params: .init(protocolVersion: "1.0",
                                            name: function.name.removed(text: mcpID + Self.separator),
                                            arguments: function.arguments))
        let response = await WebResponse<MCPResponse<ToolResult>>
            .withTimeout(20)
            .post(url: data.config.url, body: command)
        switch response {
        case .failure(let httpError):
            return "Error: \(httpError)"
        case .response(let dto, _):
            return dto.result.content.map{ $0.text }.jsonOneLine ?? "No data"
        }
    }
}

struct MCPData {
    let id: String
    let config: MCPConfig
}
