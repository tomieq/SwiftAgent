//
//  OpenAIToolFunction.swift
//  SwiftAgent
// 
//  Created by: tomieq on 29/07/2026
//




struct OpenAIToolFunction: Codable {
    let name: String
    // arguments contains a json String in format name: value
    let arguments: String
}