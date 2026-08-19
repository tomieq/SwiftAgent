# SwiftAgent

A pure Swift 6 library for talking to OpenAI-compatible and Ollama chat models, including tool calling and Model Context Protocol (MCP) tool adapters.

SwiftAgent uses Swift structured concurrency and supports macOS 10.15+, iOS 13+, and Linux.

## Installation

Add SwiftAgent to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/tomieq/SwiftAgent.git", branch: "master")
]
```

Then add the products to a target:

```swift
.product(name: "SwiftAgent", package: "SwiftAgent"),
.product(name: "MCPAdapter", package: "SwiftAgent")
```

Import the modules you use:

```swift
import SwiftAgent
import MCPAdapter
```

## Basic Chat

Create an agent with an OpenAI-compatible endpoint, create a session, then await a response.

```swift
import SwiftAgent

let config = AgentConfig(
    name: "Assistant",
    provider: .openAI,
    modelUrl: "https://api.openai.com/v1",
    authToken: ProcessInfo.processInfo.environment["OPENAI_API_KEY"]
)

let agent = SwiftAgent(config: config)
let response = try await agent
    .session(systemMessage: "You are a concise assistant.")
    .ask("What is 2 + 7?", model: "gpt-4.1-mini")

switch response.sessionReponse {
case .text(let text):
    print(text)
case .toolCall:
    break
}
```

`modelUrl` is the provider base URL. SwiftAgent appends `/chat/completions` for `.openAI` and `/api/chat` for `.ollama`. The `.openAI` provider also works with compatible services such as vLLM.

### Ollama

Use the local Ollama server by changing the configuration:

```swift
let config = AgentConfig(
    name: "Local Assistant",
    provider: .ollama,
    modelUrl: "http://localhost:11434"
)

let agent = SwiftAgent(config: config)
let response = try await agent.session().ask(
    "Explain Swift actors in one sentence.",
    model: "qwen3:1.7b"
)
```

### Discovering Models

Fetch the models exposed by the configured provider:

```swift
let models = await config.models()
print(models)
```

## Tool Calling

Declare the tools available to the model when constructing the agent. When the model requests a tool, execute it in your application and submit one `ToolResponse` for each call. Continue until the session produces text.

```swift
let weatherTool = Tool(
    name: "weather",
    description: "Returns the current weather for a city.",
    inputSchema: JSONSchema(
        type: "object",
        properties: [
            "city": .init(
                type: .string,
                description: "City name",
                enumValues: nil
            )
        ],
        required: ["city"]
    ),
    outputSchema: nil
)

let agent = SwiftAgent(config: config, tools: [weatherTool])
let session = agent.session()
var response = try await session.ask("What is the weather in Warsaw?", model: "gpt-4.1-mini")

while case .toolCall(let calls) = response.sessionReponse {
    let toolResponses = calls.map { call in
        ToolResponse(
            id: call.id,
            toolName: call.function.name,
            toolResponse: #"{"temperatureC": 18, "condition": "cloudy"}"#
        )
    }
    response = try await session.toolResponse(toolResponses, model: "gpt-4.1-mini")
}

if case .text(let answer) = response.sessionReponse {
    print(answer)
}

print("Tokens used: \(session.usedTokens)")
```

Tool arguments are available in `call.function.arguments` as `[String: JSONValue]`.

## MCP Adapter

`MCPAdapter` discovers tools from one or more HTTP MCP servers and adapts them to SwiftAgent `Tool` values. Tool names are namespaced automatically, so an adapter can connect to multiple servers.

```swift
import MCPAdapter
import SwiftAgent

let adapter = MCPAdapter(configs: [
    MCPConfig(name: "jira", url: "http://localhost:8089/mcp")
])

let tools = await adapter.getTools()
let agent = SwiftAgent(config: config, tools: tools)
let session = agent.session()
var response = try await session.ask(
    "Summarize issue SEES-5937.",
    model: "gpt-4.1-mini"
)

while case .toolCall(let calls) = response.sessionReponse {
    let toolResponses = await withTaskGroup(of: ToolResponse.self, returning: [ToolResponse].self) { group in
        for call in calls {
            group.addTask {
                ToolResponse(
                    id: call.id,
                    toolName: call.function.name,
                    toolResponse: await adapter.call(function: call.function)
                )
            }
        }

        var responses: [ToolResponse] = []
        for await toolResponse in group {
            responses.append(toolResponse)
        }
        return responses
    }

    response = try await session.toolResponse(toolResponses, model: "gpt-4.1-mini")
}
```

## Configuration

`AgentConfig` accepts the following values:

| Property | Description |
| --- | --- |
| `name` | Application-defined agent name. |
| `provider` | `.openAI` for OpenAI-compatible APIs or `.ollama` for Ollama. |
| `modelUrl` | Base URL for the provider API. |
| `authToken` | Optional bearer token. |
| `preferredModel` | Optional application-defined preferred model. |
| `maxThinkingTimeInSecods` | Request timeout in seconds; defaults to `60`. |

## Development

Build the package on macOS:

```sh
swift build
```

Build with Swift 6.1 on Linux:

```sh
rm -rf .build
docker run --rm -t -v "$PWD":/workspace -w /workspace swift:6.1 swift build
```