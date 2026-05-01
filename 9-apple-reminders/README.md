# Apple Reminders MCP

Pointer + skill, not a bundle. Lets Claude read, create, complete, and search reminders in Apple's native Reminders.app — same data your iPhone, iPad, and Mac all share via iCloud.

The upstream MCP server is `@griches/apple-reminders-mcp` — npm package, AppleScript-backed, MIT, ~1.0 stable.

## Where to get it

[`@griches/apple-reminders-mcp`](https://www.npmjs.com/package/@griches/apple-reminders-mcp)
Source: https://github.com/griches/apple-mcp/tree/main/reminders

## What you need

| Thing | Why |
|---|---|
| macOS 13+ | Reminders.app + AppleScript automation |
| Node.js 18+ | The MCP server runs via npx |
| Claude Desktop OR Claude Code | MCP client |
| iCloud signed in (optional but recommended) | Reminders sync across your devices |

## Setup (~5 min)

### 1. Wire to Claude

For **Claude Desktop**, add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "apple-reminders": {
      "command": "npx",
      "args": ["-y", "@griches/apple-reminders-mcp"]
    }
  }
}
```

For **Claude Code**, run:

```bash
claude mcp add apple-reminders -- npx -y @griches/apple-reminders-mcp
```

Restart Claude.

### 2. Grant Automation permission

The first time Claude tries to read reminders, macOS will pop a TCC prompt asking to allow Claude (or whichever process is spawning the MCP) to control Reminders.app. Click **OK**.

If you want to pre-grant (recommended on a mobile-heavy workflow where you might miss the prompt):

System Settings → Privacy & Security → **Automation** → find your Claude binary → toggle **Reminders** on.

You can also pre-trigger the prompt by running a quick query yourself:

```bash
osascript -e 'tell application "Reminders" to count of lists'
```

If the prompt appears, click Allow. If you get `AppleEvent timed out`, the prompt was missed — check the Automation pane.

### 3. Test it

In Claude:

> "What's on my Reminders list today?"
> "Add 'pick up dry cleaning' to my Errands list, due tomorrow"
> "Mark all reminders containing 'milk' as complete"

If the MCP is wired correctly, Claude lists/creates/completes through the actual Reminders.app and you see the change reflected on iPhone within a few seconds (assuming iCloud sync).

## Tools exposed

The server exposes 11 MCP tools:

| Tool | Purpose |
|---|---|
| `list_lists` | Show all reminder lists |
| `create_list` | Add a new list |
| `delete_list` | Remove a list (and all its reminders) |
| `list_reminders` | Show reminders in a list, with optional include-completed |
| `get_reminder` | Pull full details by name or ID |
| `create_reminder` | Add a reminder with optional due date, notes, priority |
| `update_reminder` | Modify name, notes, due date, priority, list |
| `complete_reminder` | Mark done |
| `uncomplete_reminder` | Mark incomplete |
| `delete_reminder` | Remove |
| `search_reminders` | Find by name across all lists |

## Why we use it

- **Apple-first workflow.** If you live on iPhone, Mac, and iPad, Reminders is already in front of you constantly. Capture-rate is higher than with a separate task tool.
- **iCloud sync is free and instant.** No third-party service, no extra account.
- **Voice + Siri.** Anything Claude adds shows up when Siri reads "what's on my list" on AirPods, in CarPlay, etc.
- **Lists as namespaces.** "Errands", "Groceries", "Hiilite", "Personal" lets the agent scope by context.

Pairs nicely with `2-agents/jimmy.md` (executive assistant) and `4-heartbeat-tmux/` (the heartbeat can pull pending reminders into its briefing).

## Caveats

- **AppleScript-backed.** Despite the upstream README claiming EventKit, our test showed AppleScript timeouts before Automation permission was granted. Functional, just not as fast or robust as a native EventKit binding would be.
- **Subscribed/shared lists.** Our testing has been on personal iCloud lists. Shared lists from other family members may have edge cases — the MCP doesn't filter, but writes back to a shared list trigger an iCloud sync that takes a few seconds longer.
- **Notification spam.** If you bulk-create 50 reminders with due dates, each one fires a notification. Either don't set due dates on bulk imports, or expect the buzz.
- **Upstream not ours.** This is `griches`'s project. File issues at https://github.com/griches/apple-mcp, not here.

## Alternatives

| Package | Why you might prefer it |
|---|---|
| [`@zyx1121/apple-reminders-mcp`](https://www.npmjs.com/package/@zyx1121/apple-reminders-mcp) | More iteration on its versioning (v0.2.x); slightly different tool surface. Try if `@griches` breaks. |
| [`apple-reminders-mcp`](https://www.npmjs.com/package/apple-reminders-mcp) (`hirai8`) | Wraps a separate `remindctl` CLI. More moving parts but possibly more robust read perf at scale. |
