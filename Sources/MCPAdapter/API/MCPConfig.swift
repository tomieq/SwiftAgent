//
//  MCPConfig.swift
//  SwiftAgent
//
//  Created by: tomieq on 30/07/2026
//
import Foundation

public struct MCPConfig {
    public let name: String
    let url: String
    let authToken: String?
    let requestTimeout: TimeInterval

    public init(name: String, url: String, authToken: String? = nil, requestTimeout: TimeInterval = 20) {
        self.name = name
        self.url = url
        self.authToken = authToken
        self.requestTimeout = requestTimeout
    }
}
