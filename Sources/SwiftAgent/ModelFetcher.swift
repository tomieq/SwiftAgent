//
//  ModelFetcher.swift
//  SwiftAgent
//
//  Created by: tomieq on 03/08/2026
//

import WebResponse
import Logger

final class ModelFetcher<T: ModelList> {
    private let logger = Logger(ModelFetcher.self)

    func fetch(_ config: AgentConfig) async -> [String] {
        var headers: [String: String] = [:]
        if let token = config.authToken {
            headers["Authorization"] = "Bearer \(token)"
        }
        logger.i(config.modelUrl.trimming("/") + config.provider.modelsPath)
        let response = await WebResponse<T>
            .withTimeout(2)
            .get(url: config.modelUrl.trimming("/") + config.provider.modelsPath, headers: headers)
        switch response {
        case .failure(let error):
            logger.e("Error fetching models: \(error)")
            return []
        case .response(let body, _):
            return body.modelList
        }
    }
}
