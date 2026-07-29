//
//  SessionResponse.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//

public enum SessionResponse: Equatable {
    case text(String)
    case functionCall(FunctionCall)
}
