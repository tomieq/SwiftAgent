import Testing
import SwiftAgent

@Test func localTest() async throws {
    let config = AgentConfig(
        provider: .ollama,
        modelUrl: "http://localhost:11434/"
    )
    
    let agent = SwiftAgent(config: config)
    let response = try await agent.ask("What is 2+7", model: "gemma4:e4b")
    print(response)
}
