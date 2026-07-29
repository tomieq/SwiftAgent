//
//  MCPResponse.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//

struct MCPResponse<T: Codable>: Codable {
    let jsonrpc: String
    let id: Int?
    let result: T
}
