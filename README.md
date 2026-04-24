# Hiilite Share

Modular pieces from a working Claude Code agent stack. Grab whatever's useful.
Each folder is independent — clone the repo or just download the folder you want.

## Folders

| # | Folder | What it is | Setup time |
|---|---|---|---|
| 1 | `1-marketing-skills/` | 57 skills: ads (Meta/Google/LinkedIn/TikTok/Microsoft), SEO, CRO, copy, hormozi-brain | 5 min |
| 2 | `2-agents/` | 18 specialist sub-agents (Gary, Ricky, Sofia, Marcus, Theo, audits, etc.) | 5 min |
| 3 | `3-telegram-bot/` | Telegram bridge — bot wiring, watchdog, status updates while Claude works | 30 min |
| 4 | `4-heartbeat-tmux/` | Persistent Claude Code session: tmux + launchd + 3x daily proactive heartbeat | 30 min |
| 5 | `5-adobe-mcp/` | Pointer to Adobe Creative Suite MCP (Photoshop + Premiere + AE) | 15 min |
| 6 | `6-wordpress-helpers/` | WP-CLI ops, Gravity Forms, Yoast schema, plugin scaffold patterns | 30 min |
| 7 | `7-ctrl-motion-lite/` | Forkable code — local "projects + tasks + AI meeting notes + dispatch" app, repo at [Dartagnan98/motion-lite](https://github.com/Dartagnan98/motion-lite) | 15 min |

## Prerequisites (the "what you need to connect" list)

Each folder has its own `SETUP.md` with specifics. Top-level summary:

| Service | Why | Required for |
|---|---|---|
| Claude Code CLI | The whole thing runs inside it | All folders |
| Anthropic API key OR Claude subscription | Powers the agent | All folders |
| Telegram BotFather token | Talk to your bot from your phone | 3, 4 |
| Telegram chat ID (your own) | Where the bot replies | 3, 4 |
| Google OAuth client | gws CLI for Drive/Calendar/Gmail | Some skills in 1 |
| Meta Developer app + ad account access | Run ad audits/launches | ads-meta in 1 |
| Google Ads dev token + OAuth | Same for Google Ads | ads-google in 1 |
| WordPress site with REST API + admin password | Optional — for WP automation | 6 |
| (nothing extra) | motion-lite uses local SQLite — Anthropic key is the only required service | 7 |

## Install style

These are skills + agents, not a deployable app. Workflow:

```bash
git clone <this repo>
cd hiilite-share/

# Install skills (copies them into your Claude config dir)
cp -R 1-marketing-skills/skills/* ~/.claude/skills/

# Install agents
cp -R 2-agents/*.md ~/.claude/agents/

# Restart claude code → /skill list and /agent list will show the new ones
```

Per-folder READMEs explain the bits that need extra wiring (Telegram, launchd, etc.).

## License

MIT. Use freely. Originally built by your agency for our own client work,
sharing because the tech stack overlaps with yours and the heavy lifting is
already done.

## Caveats

- Skills reference paths like `~/your-knowledge-base/clients/<client>/` — adapt to your own knowledge layout.
- Voice files / brand voice references are stripped. You'll define your own per-client voice in your MEMORY/knowledge dir.
- Heartbeat scripts assume macOS launchd. Linux equivalent is systemd timers (5-min adapt).
- Telegram bot uses long-polling — no public webhook URL needed.
