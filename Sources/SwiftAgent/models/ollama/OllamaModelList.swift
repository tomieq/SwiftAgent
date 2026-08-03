//
//  OllamaModelList.swift
//  SwiftAgent
//
//  Created by: tomieq on 03/08/2026
//

struct OllamaModelList: ModelList {
    struct Model: Codable {
        let name: String
    }

    let models: [Model]

    var modelList: [String] { models.map(\.name) }
}
