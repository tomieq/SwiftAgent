//
//  ModelRequest.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//

protocol ModelRequest: Codable {
    init(model: String, messages: [ModelMessage], tools: [CommonTool]?)
}
