//
//  ToolFunction.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//

public struct FunctionCall: Codable, Equatable {
    public let name: String
    public let arguments: [String: JSONValue]

    public init(name: String, arguments: [String: JSONValue]) {
        self.name = name
        self.arguments = arguments
    }
}
