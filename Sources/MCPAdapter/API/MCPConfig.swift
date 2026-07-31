//
//  MCPConfig.swift
//  SwiftAgent
//
//  Created by: tomieq on 30/07/2026
//

public struct MCPConfig {
    let name: String
    let url: String
    let authToken: String?

    public init(name: String, url: String, authToken: String? = nil) {
        self.name = name
        self.url = url
        self.authToken = authToken
    }
}
