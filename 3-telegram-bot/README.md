# Telegram Bot Bridge

Pipe a Telegram chat into Claude Code so you can drive it from your phone.

## Two layers

1. **Anthropic's official Telegram plugin** — the actual bot bridge (Claude reads/writes via Telegram Bot API)
2. **Watchdog script** (`telegram-watchdog.sh`) — sends "thinking..." status updates to Telegram while Claude is working a long task. Optional but nice.

## What you need

| Thing | Where to get it |
|---|---|
| Telegram Bot Token | DM `@BotFather` on Telegram → `/newbot` → follow prompts |
| Your Telegram chat ID | DM `@userinfobot` → it replies with your `id:` |
| Claude Code CLI installed | `curl -fsSL https://anthropic.com/install.sh \| sh` |

## Setup (10 min)

### 1. Install the Telegram plugin

```bash
# In Claude Code:
/plugin install telegram@claude-plugins-official
```

### 2. Run the access skill to authorize your Telegram account

```bash
/telegram:access
```

Follow the prompts — it will ask for your bot token and your chat ID, then write them to `~/.claude/plugins/data/telegram/access.json`.

### 3. Restart Claude Code

The plugin connects via long-polling (no public URL needed) and starts forwarding messages.

### 4. (Optional) Wire the watchdog

The watchdog sends typing indicators + status messages so you can see what Claude is doing on long tasks.

```bash
# Set env vars
export TELEGRAM_BOT_TOKEN="<your bot token>"
export YOUR_TELEGRAM_CHAT_ID="<your chat id>"
export PROJECT_DIR="$HOME/agent-session"  # where you run claude

# Test it
./telegram-watchdog.sh
```

To run it in the background as a launchd service:

```bash
# Edit telegram-watchdog.plist.template — replace ${} placeholders with real paths/values
# Save as ~/Library/LaunchAgents/com.<youragency>.telegram-watchdog.plist
launchctl load ~/Library/LaunchAgents/com.<youragency>.telegram-watchdog.plist
```

## Files

- `telegram-watchdog.sh` — the status-update loop. Reads tmux session output, posts elapsed time + current tool to Telegram, deletes when Claude goes idle.
- `telegram-watchdog.plist.template` — launchd config to run the watchdog at login. Edit the path placeholders.

## Caveats

- The watchdog assumes you're running Claude inside a tmux session named `agent-session` (matches `4-heartbeat-tmux/`). Edit `SESSION=` at the top of the script if you use a different name.
- Long-poll has 1 webhook per bot token. If you have multiple instances polling, messages get eaten. The keep-alive script in `4-heartbeat-tmux/` handles this with `pkill -f 'bun.*telegram.*start'` before restart.
- Voice messages come through with `attachment_file_id` — use `download_attachment` then transcribe with whisper.cpp or similar.
