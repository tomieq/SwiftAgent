//
//  LocalModelTests.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//

import Testing
import SwiftAgent
import Logger

struct LocalOllamaTests {
    let model = "gemma4:e4b"
//    let model = "qwen3:1.7b"
    let config = AgentConfig(
        provider: .ollama,
        modelUrl: "http://localhost:11434/"
    )

    @Test func localOllamaSimpleCalculation() async throws {
        LoggerDispatcher.logLevel = .error
        let agent = SwiftAgent(config: config)
        let session = agent.session(systemMessage: "You are Math teacher. Help user with his tasks.")
        let response = try await session.ask("How many is 4+8?. Return just a number", model: model)
        print(response)
        #expect(response == .text("12"))
        print("Used tokens: \(session.usedTokens)")
    }

    @Test func localOllamaToolCall() async throws {
        let jiraTool = Tool(
            name: "jira_get_issue",
            description: "Returns details of a Jira issue.",
            inputSchema: .init(
                type: "object",
                properties: [
                    "jiraID": .init(
                        type: .string,
                        description: "Issue key such as CLOUD-34733",
                        enumValues: nil
                    )
                ],
                required: ["jiraID"]
            )
        )
        let agent = SwiftAgent(config: config, tools: [jiraTool])
        let session = agent.session()
        let response = try await session.ask("What the jira CLOUD-7863 is all about?", model: model)
        print(response)
//        #expect(response == .functionCall(FunctionCall(name: "jira_get_issue", arguments: ["jiraID": .string("CLOUD-7863")])))
        print("Used tokens: \(session.usedTokens)")
    }
}
