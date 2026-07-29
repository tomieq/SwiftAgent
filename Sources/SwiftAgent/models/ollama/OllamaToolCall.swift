//
//  OllamaToolCall.swift
//  SwiftAgent
// 
//  Created by: tomieq on 29/07/2026
//




struct OllamaToolCall: Codable {
    let type = "function"
    let function: OllamaToolFunction
    let id: String
}