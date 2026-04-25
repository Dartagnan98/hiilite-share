---
name: imessage
description: When the user wants Claude to read, analyze, draft replies for, or send iMessages on their Mac. Triggers include "check my texts", "draft a reply to X", "what did Y say last night", "respond to Z for me", "send a text to ...", "build my brand voice", "analyze how I write", "make this sound like me", "sound like me", "stay in voice", "set up the voice file". Two big jobs: (1) capture the user's writing voice from real iMessage history → brand-voice.md that every other marketing skill picks up; (2) operate iMessage end-to-end (read recent, draft, send) so Claude can respond on the user's behalf.
metadata:
  version: 1.0.0
---

# iMessage

Local Mac iMessage integration. Two capabilities, both backed by `~/Library/Messages/chat.db` (read) and the macOS Messages app (write):

1. **Voice capture** — pull the user's outbound history per-person per-day, run analysis, write `~/.brand-voice/brand-voice.md`. Every other skill in this bundle reads that file before generating copy so output stays in voice.
2. **Operate iMessage** — list recent inbound, draft a reply in voice, send the reply via the Messages app.

## When to invoke

- **Setup / voice work**: "set up brand voice", "build my voice", "analyze how I write", "extract my tone".
- **Read**: "what did Skyleigh send today", "show me the last 10 from Antonio", "any unread texts".
- **Draft**: "draft a reply to Joe about X", "what should I send back".
- **Send**: "send Antonio: <message>", "tell Skyleigh ...".
- **Background**: any time the user says "respond for me", "handle this thread", "stay on top of texts" — combine read → draft → confirm → send.

## File layout

All artifacts under `~/.brand-voice/`:

- `~/.brand-voice/contacts.json` — phone (E.164) or email → person folder name. Owned by the user, never overwritten.
- `~/.brand-voice/comms/<person>/<YYYY-MM-DD>.md` — per-person daily digests of outbound messages
- `~/.brand-voice/samples/*.md` — any other writing samples the user drops in (emails, sales pages)
- `~/.brand-voice/brand-voice.md` — analyzed guardrails (the file every other skill reads)
- `~/.brand-voice/inbound/<person>/<YYYY-MM-DD>.md` — per-person daily digests of inbound messages (used by draft-reply.sh)

## Operating modes

### Mode 1: First-time setup

```
bash scripts/setup.sh
```

Creates `~/.brand-voice/`, prompts for `ANTHROPIC_API_KEY`, copies the contacts template, and (optionally) installs a daily LaunchAgent that re-pulls history at 2am.

User must grant Terminal/iTerm/Claude Code "Full Disk Access" in System Settings → Privacy & Security so we can read `~/Library/Messages/chat.db`.

### Mode 2: Pull history (outbound — for voice)

```
bash scripts/pull-imessage.sh [--days 90] [--rebuild]
```

Pulls the user's outbound messages by handle into `~/.brand-voice/comms/<person>/<date>.md`. Used to feed the voice analyzer.

### Mode 3: Pull recent (inbound — for replies)

```
bash scripts/pull-inbound.sh [--days 7]
```

Pulls inbound messages into `~/.brand-voice/inbound/<person>/<date>.md`. Run before drafting a reply so Claude has fresh context.

### Mode 4: Analyze voice → brand-voice.md

```
bash scripts/analyze.sh
```

Reads everything under `~/.brand-voice/comms/` and `~/.brand-voice/samples/`, calls Claude Sonnet 4.6, writes `~/.brand-voice/brand-voice.md`.

### Mode 5: Draft a reply

```
bash scripts/draft-reply.sh <person>
```

Reads the latest `~/.brand-voice/inbound/<person>/` files, prepends `brand-voice.md`, asks Claude for a one-message reply in voice. Prints to stdout — the user reviews and confirms before sending.

### Mode 6: Send

```
bash scripts/send.sh <handle> <message>
```

Sends a real iMessage via AppleScript / Messages app. `<handle>` is the phone (E.164) or email; `<message>` is the text. Always confirm with the user before invoking — sending is irreversible.

## Reading the voice file from other skills

Every other marketing skill should, before generating copy:

```bash
[ -f ~/.brand-voice/brand-voice.md ] && cat ~/.brand-voice/brand-voice.md
```

…and prepend the contents to its system prompt as "Brand voice guardrails — adhere to these in everything you generate." If the file doesn't exist, the skill proceeds normally.

## Output format of brand-voice.md

```markdown
# Brand Voice

> Generated on YYYY-MM-DD from N writing samples (M words analyzed).

## Rationale
<one paragraph>

## Tone
- direct
- calm
...

## Do words
- plain english
...

## Avoid words
- delve
...

## Style rules
- Lead with the result, not the setup.
...
```

## Privacy

Everything under `~/.brand-voice/` is local. The only egress is the analysis call to Anthropic (the user's own API key). Don't commit `~/.brand-voice/` to git, don't sync it, don't ship it.

## Safety rails

- **Never auto-send.** Claude drafts; the user confirms; only then `send.sh` runs.
- **Don't pull other people's outbound messages.** `pull-imessage.sh` only writes `is_from_me=1` rows. The voice file is the user's voice, not their friends'.
- **Inbound pulls are local-only and per-handle.** They exist solely to give Claude context for drafting.

## Troubleshooting

- **"unable to open database file"** — Mac needs Full Disk Access for the shell process. System Settings → Privacy & Security → Full Disk Access → toggle on Terminal/iTerm/VS Code/Claude Code.
- **"Anthropic call failed"** — check key in `~/.brand-voice/.env`, must start with `sk-ant-`.
- **Voice file doesn't sound like me** — pull more days (`--days 180`) and re-run `analyze.sh`. More samples = sharper voice.
- **send.sh fails** — Messages app must be signed into iCloud/iMessage. Recipient must be a Messages contact (blue or green bubble).
