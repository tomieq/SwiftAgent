//
//  OpenAIModelList.swift
//  SwiftAgent
//
//  Created by: tomieq on 03/08/2026
//

struct OpenAIModelList: ModelList {
    struct Model: Codable {
        let id: String
    }

    let data: [Model]

    var modelList: [String] { data.map(\.id) }
}
