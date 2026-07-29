//
//  Command.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//
import SwiftAgent

struct Command: Codable {
    let id: Int?
    let method: String
    let params: Params?

    struct Params: Codable {
        let protocolVersion: String?
        let name: String?
        let arguments: [String: JSONValue]?
    }
}
