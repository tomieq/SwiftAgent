//
//  OpenAIToolCall.swift
//  SwiftAgent
// 
//  Created by: tomieq on 29/07/2026
//




struct OpenAIToolCall: Codable {
    let type = "function"
    let function: OpenAIToolFunction
    let id: String
}