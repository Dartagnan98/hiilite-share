# Adobe Creative Suite MCP

Pointer, not a bundle. The best Adobe MCP we've found is `mikechambers/adb-mcp` — Photoshop + Premiere Pro + After Effects, all driven from Claude.

## Where to get it

https://github.com/mikechambers/adb-mcp

> 576+ stars, actively maintained, MIT license. The Premiere panel is functional for cuts/markers/text/timeline ops.

## What you need

| Thing | Why |
|---|---|
| macOS or Windows | Adobe apps only run on these |
| Adobe Creative Cloud subscription | Photoshop / Premiere / After Effects installed and licensed |
| Node.js 18+ | The MCP server is Node |
| Claude Desktop OR Claude Code | Either works as the MCP client |

## Setup (15 min)

### 1. Clone and install

```bash
git clone https://github.com/mikechambers/adb-mcp ~/code/adb-mcp
cd ~/code/adb-mcp
npm install
npm run build
```

### 2. Install the UXP panels into your Adobe apps

Inside Photoshop / Premiere / AE → Plugins → UXP Developer Tool → load the panel folder from the cloned repo. Mike's README has app-by-app instructions.

### 3. Wire to Claude

For **Claude Desktop**, add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "adobe": {
      "command": "node",
      "args": ["/Users/YOU/code/adb-mcp/dist/server.js"]
    }
  }
}
```

For **Claude Code**, add to `~/.claude/claude_code_config.json` (same shape).

Restart Claude.

### 4. Test it

In Claude:

> "Open the file at /tmp/test.psd in Photoshop and add a black rectangle on a new layer"

If the MCP is wired correctly, Claude calls the Adobe tool, the panel takes the action in Photoshop, and you see the layer appear.

## Why we use it

For the ads workflow we run:
- **Photoshop** — batch resize creative for platform specs (1080x1080, 1080x1920, 1200x628), apply brand templates, swap copy
- **Premiere** — assemble UGC clips with captions, add B-roll cuts, render for IG Reels / TikTok
- **AE** — text animations, logo stings, motion graphics templates

Pairs nicely with `1-marketing-skills/skills/ad-image-gen` (image generation) and `ads-creative` (creative strategy).

## Caveats

- UXP panels need to be reloaded if you update the MCP server code.
- Premiere automation is the most fragile of the three — Adobe's UXP API for Premiere is younger than Photoshop's.
- This is upstream's project, not ours. File issues at the repo above, not here.
