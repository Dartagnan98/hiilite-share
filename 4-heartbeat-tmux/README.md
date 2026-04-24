# Heartbeat + Persistent tmux Session

A Claude Code session that stays alive 24/7 in tmux + runs proactive agentic check-ins 3x/day.

## What it does

- **claude-keep-alive.sh** — boots Claude Code inside a named tmux session, restarts on exit, kills stale Telegram pollers before each restart. Wired to launchd `KeepAlive` so it survives reboots.
- **smart-heartbeat.sh** — fires 3x/day. Each run is *agentic*: it builds context (recent comms, git, todos), invokes `claude --print` with action primitives (send iMessage, queue WA, log task), and writes a Telegram briefing of what was DONE, not what should be done.
- **heartbeat-context.sh** — assembles the context bundle the heartbeat run reads (prior run handoff, last 24h comms, git log, current todo list).
- **heartbeat.plist.template** — launchd schedule for 6:30am / 1:00pm / 5:00pm.

## What you need

| Thing | Why |
|---|---|
| macOS with launchd | Schedule lives in `~/Library/LaunchAgents/` (Linux equivalent: systemd timer) |
| tmux | `brew install tmux` |
| Claude Code installed at `~/.local/bin/claude` | Adjust path in `claude-keep-alive.sh` if different |
| Telegram bundle 3 working | Heartbeat sends briefing to your chat |
| Your own `agent_log.py` (or stub it out) | Heartbeat references it for run tracking + action logging |
| Voice / persona file | Heartbeat reads a markdown file of your tone preferences. Path is `VOICE_FILE=` near the top of the script |

## Setup

### 1. Pick a project directory

This is where Claude runs. Heartbeats expect:

```
$PROJECT_DIR/
├── scripts/
│   ├── smart-heartbeat.sh
│   ├── heartbeat-context.sh
│   ├── claude-keep-alive.sh
│   ├── agent_log.py     # YOU WRITE THIS (or stub it)
│   ├── imsg-send.sh     # optional — for iMessage replies
│   └── wa-send.sh       # optional — for WhatsApp replies
├── logs/
└── store/               # heartbeat run state, sqlite
```

Copy the four .sh / .plist files from this folder into `$PROJECT_DIR/scripts/`.

### 2. Stub the action helpers

`smart-heartbeat.sh` calls these — if you don't have them yet, create no-op stubs so the heartbeat doesn't crash:

```bash
# scripts/agent_log.py — bare minimum
import sys, json, time
cmd = sys.argv[1]  # "run-start", "run-end", "action", "draft"
print(json.dumps({"run_id": str(int(time.time())), "ok": True}))
```

```bash
# scripts/imsg-send.sh — stub
echo "[stub] would iMessage: $@"
```

```bash
# scripts/wa-send.sh — stub
echo "[stub] would WhatsApp: $@"
```

Replace with real implementations later (iMessage via `osascript`, WhatsApp via Twilio or wa-automate).

### 3. Tmux keep-alive

```bash
# Test it manually first
bash claude-keep-alive.sh
# In another terminal: `tmux attach -t agent-session` to see Claude running
```

Then wire to launchd. Create `~/Library/LaunchAgents/com.youragency.claude-keep-alive.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.youragency.claude-keep-alive</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>${HOME}/agent-session/scripts/claude-keep-alive.sh</string>
    </array>
    <key>RunAtLoad</key><true/>
    <key>KeepAlive</key><true/>
    <key>StandardOutPath</key>
    <string>${HOME}/agent-session/logs/keep-alive.log</string>
    <key>StandardErrorPath</key>
    <string>${HOME}/agent-session/logs/keep-alive-err.log</string>
</dict>
</plist>
```

```bash
launchctl load ~/Library/LaunchAgents/com.youragency.claude-keep-alive.plist
```

### 4. Schedule the heartbeat

Edit `heartbeat.plist.template` — replace `${PROJECT_DIR}` and `${HOME}` with absolute paths. Save as `~/Library/LaunchAgents/com.youragency.heartbeat.plist`.

```bash
launchctl load ~/Library/LaunchAgents/com.youragency.heartbeat.plist
```

Test it manually first:

```bash
bash scripts/smart-heartbeat.sh Morning
# Should write a briefing to /tmp/heartbeat-briefing-*.md
```

## Caveats

- **launchd, not cron** — cron has no Keychain access, so `claude --print` fails because OAuth tokens live in Keychain. Always use launchd on macOS.
- **One bot token per polling instance** — kill stale pollers before restart (`pkill -f 'bun.*telegram.*start'`). The keep-alive script already does this.
- **Subscription auth** — `smart-heartbeat.sh` explicitly `unset ANTHROPIC_API_KEY` so it falls back to your Claude Code subscription. If you want API billing instead, remove those unsets and export the key.
- **Voice file** — `VOICE_FILE=` near the top of the script points at a markdown file describing your tone. Without it the heartbeat still runs, just without persona shaping. Write your own — examples include "no em dashes," "no AI cliches," "tight summary first."
- **TZ-sensitive** — `HOUR` is computed in `America/Los_Angeles`. Edit if you're elsewhere.
- **Logs** — everything writes to `$PROJECT_DIR/logs/heartbeat-*.log`. Tail those when debugging.
