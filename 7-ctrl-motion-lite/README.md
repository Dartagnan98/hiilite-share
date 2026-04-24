# Motion Lite (forkable code)

Stripped-down fork of the internal CRM. Productivity core only — projects, tasks, docs, AI meeting notes, dispatch.

**Repo:** https://github.com/Dartagnan98/motion-lite

## What it is

The full CRM has CRM, contacts, messaging, ad platform integrations (Meta/Google), Square sync, GHL bridge, Stripe, etc. Motion Lite has all of that ripped out. What's left:

- **Projects** — workspaces → folders → projects → stages → tasks
- **Tasks** — kanban + list + timeline, drag-to-reorder, priority/effort/due
- **Docs** — Tiptap markdown editor attached to projects
- **Meeting Notes** — paste a transcript or pipe via email; Anthropic summarizes + extracts action items + auto-creates tasks
- **Brain** — knowledge graph view of your projects/docs
- **Dispatch** — agentic task queue + bridge pattern to forward jobs to a local Mac
- **Today / Agenda** — daily planning surface

## Stack

- Next 16 (app router, React 19, server actions)
- **better-sqlite3** — local file DB. No Supabase, no external DB service needed.
- Anthropic SDK
- Tiptap editor
- Optional: IMAP for email transcript ingest, Electron desktop wrapper

## What you need

| Thing | Why |
|---|---|
| Node 20+ | Required to build/run |
| Anthropic API key | Required for AI meeting notes + dispatch summarization |
| (Optional) Email + IMAP creds | If you want meeting bot transcripts auto-ingested |
| (Optional) VAPID keys | If you want web push notifications |

That's it. No Google OAuth, no Meta tokens, no Stripe, no GHL — those integrations were stripped.

## Setup (15 min)

```bash
git clone https://github.com/Dartagnan98/motion-lite ~/code/motion-lite
cd ~/code/motion-lite
npm install
mkdir -p ~/code/store      # parallel to motion-lite — SQLite DB lives here
cp .env.example .env.local
# edit .env.local, set ANTHROPIC_API_KEY
npm run dev
# open http://localhost:4000
```

Full setup details + dispatch architecture in the repo's own README.

## "Not perfect but close"

Heads up — this is a strip-and-scrub of a production app, not a clean greenfield build:

- Some routes may import deleted CRM code → fix by deleting the route or stubbing the import
- Settings page still shows ad-platform integration tabs (no-op placeholders)
- Single-tenant assumed (multi-workspace works, cross-user RLS not hardened)
- Schema migrates auto on boot — if you upgrade and break, delete `../store/motion.db` and start fresh
- Electron wrapper builds but is untested in lite

If you hit a wall, message the friend who shared this and they'll help debug.

## Why we forked instead of giving the full thing

The full CRM has client data baked into the schema, hardcoded business logic for specific clients, and integrations to ad accounts that aren't yours. Motion Lite is the part that's *just yours-to-use* without inheriting any of that.

## Dispatch — the interesting bit

If you want to see how the "cloud app enqueues a task → local Mac runs Claude → result flows back" pattern works, the `/dispatch` route + `src/app/api/dispatch/` is where to look. The repo README has the bridge architecture diagram + a starter poller script.

This is the closest thing to "Jimmy" (the personal assistant pattern) you can run on your own machine.
