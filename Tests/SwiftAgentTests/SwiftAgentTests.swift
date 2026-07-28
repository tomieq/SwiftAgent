import Testing
import SwiftAgent

@Test func example() async throws {
    let config = AgentConfig(modelUrl: "http://localhost:11434/api/generate")
    
    let agent = SwiftAgent(config: config)
    let response = try await agent.ask("What is 2+7", model: "gemma4:e4b")
    print(response)
}
