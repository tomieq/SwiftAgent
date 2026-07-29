//
//  LocalModelTests.swift
//  SwiftAgent
//
//  Created by: tomieq on 29/07/2026
//

import Testing
import SwiftAgent

struct LocalOllamaTests {
    let model = "gemma4:e4b"
//    let model = "qwen3:1.7b"

    @Test func localOllamaSimpleCalculation() async throws {
        let config = AgentConfig(
            provider: .ollama,
            modelUrl: "http://localhost:11434/"
        )

        let agent = SwiftAgent(config: config)
        let response = try await agent.session.ask("How many is 4+8?. Return just a number", model: model)
        print(response)
        #expect(response == .text("12"))
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

        let config = AgentConfig(
            provider: .ollama,
            modelUrl: "http://localhost:11434/"
        )

        let agent = SwiftAgent(config: config, tools: [jiraTool])
        let response = try await agent.session.ask("What the jira CLOUD-7863 is all about?", model: model)
        print(response)
        #expect(response == .functionCall(FunctionCall(name: "jira_get_issue", arguments: ["jiraID": .string("CLOUD-7863")])))
    }
}
