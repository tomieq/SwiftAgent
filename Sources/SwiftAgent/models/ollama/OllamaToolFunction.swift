//
//  OllamaToolFunction.swift
//  SwiftAgent
// 
//  Created by: tomieq on 29/07/2026
//




struct OllamaToolFunction: Codable {
    let name: String
    // Ollama returns structured JSON, whose values can be numbers, booleans,
    // arrays, objects, or null as well as strings.
    let arguments: [String: JSONValue]
}