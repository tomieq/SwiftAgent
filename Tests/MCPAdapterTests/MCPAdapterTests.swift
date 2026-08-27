import Testing
@testable import MCPAdapter

@Test
func toolNamePreservesMCPNameWithinToolName() {
    #expect(MCPAdapter.toolName(from: "jira_get_jira_ticket", mcpID: "jira") == "get_jira_ticket")
}