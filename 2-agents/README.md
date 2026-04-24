# Specialist Sub-Agents

18 specialist agents you can delegate to. Each has its own scope, tools, and personality.

## Install

```bash
cp *.md ~/.claude/agents/
```

Restart Claude Code. Agents appear in `/agent` list and are invokable via the Task tool with `subagent_type: <name>`.

## The team

### Core specialists
- **gary** — Paid ads strategist (Meta primary, Google secondary). Audits, budget moves, targeting, creative briefs, benchmarks. Strategy only — never launches campaigns or moves money.
- **ricky** — Conversion-focused copywriter. Landing pages, ad headlines, hooks, email subjects, sales scripts.
- **sofia** — Social specialist (Instagram, TikTok, Reels, YouTube Shorts). Calendars, captions, scripts, hashtag packs.
- **marcus** — CRM + automations. GHL, Supabase, Buffer, Brevo, Zapier. Configures systems — doesn't write copy.
- **theo** — Researcher. Market, competitor, regulatory, vendor evaluation.
- **nina** — Analyst + reporting. Pulls from ad platforms, Square, GHL. Builds weekly/monthly reports. Read-only.
- **orchestrator** — Team lead. Reads task through Hormozi lens, decides team, delegates, synthesizes.
- **qc** — Quality control reviewer. Runs at end of pipelines. Read-only verdict: PASS / FLAG / LOOP.

### Audit specialists (6)
- **audit-budget** — budget allocation, bidding, learning phase, audience, structure
- **audit-compliance** — regulatory + ad policy + privacy
- **audit-creative** — creative diversity, fatigue, format, spec compliance
- **audit-google** — Google Ads (conversion tracking, wasted spend, structure, keywords, QS, PMax)
- **audit-meta** — Meta Ads (Pixel/CAPI health, EMQ, learning phase, Advantage+)
- **audit-tracking** — pixel install, server-side, attribution

### Creative production (4)
- **copy-writer** — Ad copy with platform-specific char counts. Outputs to file.
- **creative-strategist** — Campaign concept strategy. Reads brand profile, generates concepts.
- **visual-designer** — Image generation pipeline (banana MCP). Builds 5-component prompts.
- **format-adapter** — Validates ad asset specs. Checks safe zones. Reports missing formats.

## Setup

Agents are prompt files — no external credentials needed for the agents themselves.

What they CALL may need credentials:
- gary, audit-google, audit-meta — API access to ad accounts (Meta dev app, Google Ads dev token)
- nina — read access to ad platforms, Square, GHL
- marcus — GHL + Supabase + Brevo + Zapier API keys (when actually running automations)

See top-level `SETUP.md` for credential list.

## How to delegate

```
Task({
  description: "audit Q1 Meta spend",
  subagent_type: "audit-meta",
  prompt: "Audit account 12345 for the last 90 days. Report: structure issues, learning phase health, EMQ scores, top wasted spend. Under 500 words."
})
```

Or just say "have gary look at this" / "qc this draft" in conversation — Claude routes.

## Customizing the team

Each agent is a single .md file with frontmatter (name, description, tools) + body (personality + rules).

To add your own:
1. Copy `gary.md` as a template
2. Rewrite name, description, tools, personality
3. Drop in `~/.claude/agents/`

To change voice/scope: edit the .md directly. Changes apply on next session.
