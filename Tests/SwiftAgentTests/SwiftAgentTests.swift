import Foundation
import Testing
@testable import SwiftAgent

@Test func ollamaToolCallDecodesTypedArguments() throws {
    let response = try JSONDecoder().decode(
        OllamaResponseDto.self,
        from: Data(
            """
            {
                "model": "qwen3:1.7b",
                "message": {
                    "role": "assistant",
                    "content": "",
                    "tool_calls": [{
                        "id": "call_2kf28w90",
                        "function": {
                            "name": "jira_get_issue",
                            "arguments": {"jiraID": 7863}
                        }
                    }]
                }
            }
            """.utf8
        )
    )

    let arguments = try #require(response.message.toolCalls?.first?.function.arguments)
    #expect(arguments["jiraID"] == .integer(7863))
}

@Test func localTest() async throws {
    let config = AgentConfig(
        provider: .ollama,
        modelUrl: "http://localhost:11434/"
    )
    
    let agent = SwiftAgent(config: config)
    let response = try await agent.ask("What is 2+7", model: "gemma4:e4b")
    print(response)
}
