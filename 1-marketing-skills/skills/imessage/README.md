# iMessage skill

Read, analyze, draft, and send iMessages from Claude Code on a Mac.

Two jobs:
1. **Voice capture** — pull your outbound history per-person per-day, run analysis, write `~/.brand-voice/brand-voice.md`. Every other marketing skill in this bundle reads that file before generating copy so output stays in your voice.
2. **Operate iMessage** — list recent inbound, draft a reply in your voice, send via the Messages app.

## Quick start

```bash
# 1. One-time setup (creates ~/.brand-voice/, prompts for ANTHROPIC_API_KEY, seeds contacts.json, optional 2am LaunchAgent)
bash scripts/setup.sh

# 2. Edit ~/.brand-voice/contacts.json — map phone numbers (E.164) or emails to short folder names
#    e.g. "+16045551234": "alex"

# 3. Grant Full Disk Access:
#    System Settings → Privacy & Security → Full Disk Access → toggle on Terminal/iTerm/VS Code/Claude Code

# 4. Pull last 90 days of outbound (your voice)
bash scripts/pull-imessage.sh --days 90

# 5. Build the voice file
bash scripts/analyze.sh
# → ~/.brand-voice/brand-voice.md

# 6. (Anytime) Pull inbound + draft a reply
bash scripts/pull-inbound.sh --days 7
bash scripts/draft-reply.sh alex
# → drafts a reply in your voice. Copy/paste to send, or:

# 7. Send
bash scripts/send.sh "+16045551234" "the drafted message"
```

## What lands where

```
~/.brand-voice/
├── contacts.json              # phone/email → person folder (yours, never overwritten)
├── .env                       # ANTHROPIC_API_KEY
├── brand-voice.md             # the analyzed guardrails (other skills read this)
├── comms/<person>/<date>.md   # outbound — feeds the analyzer
├── inbound/<person>/<date>.md # inbound — feeds draft-reply
├── samples/*.md               # any other writing samples you drop in
└── launchd.log                # LaunchAgent log if installed
```

## How other skills consume the voice file

Every other marketing skill in this bundle should, before generating copy:

```bash
[ -f ~/.brand-voice/brand-voice.md ] && cat ~/.brand-voice/brand-voice.md
```

…and prepend the contents to the model's system prompt as **"Brand voice guardrails — adhere to these in everything you generate."** If the file doesn't exist, the skill proceeds normally (no guardrails).

## Safety

- `pull-imessage.sh` only writes `is_from_me=1` rows. The voice file is *your* voice, not your friends'.
- `send.sh` is the only outbound action. Always confirm with the user before invoking — sending is irreversible.
- Everything under `~/.brand-voice/` is local. Don't commit it, don't sync it.

## Refreshing

- Run `pull-imessage.sh && analyze.sh` monthly to keep the voice file current.
- Or install the LaunchAgent in `setup.sh` — it does it daily at 2am.
