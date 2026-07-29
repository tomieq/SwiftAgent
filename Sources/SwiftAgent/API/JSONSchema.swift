//
//  JSONSchema.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//

public struct JSONSchema: Codable {
    public let type: String
    public let properties: [String: Property]
    public let required: [String]?

    public init(type: String, properties: [String: Property], required: [String]?) {
        self.type = type
        self.properties = properties
        self.required = required
    }

    public struct Property: Codable {
        public let type: ValueType
        public let description: String?
        public let enumValues: [String]?

        public init(type: ValueType, description: String?, enumValues: [String]?) {
            self.type = type
            self.description = description
            self.enumValues = enumValues
        }

        enum CodingKeys: String, CodingKey {
            case type
            case description
            case enumValues = "enum"
        }

        public enum ValueType: String, Codable {
            case string
            case integer
            case number // default for Double
            case boolean
            case array
            case object
            case date
            case uuid
            case any
        }
    }
}