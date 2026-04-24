# your CRM Lite (recipe)

This isn't a bundle — it's a recipe for forking a small subset of our CRM into a local "projects + tasks + AI meeting notes" app you can run on your own machine.

The original (your CRM) is our full client CRM. The "lite" version strips out CRM, contacts, messaging, ad integrations — keeps only:

- Projects
- Tasks (with kanban + list views)
- AI meeting notes (transcript in → summary + tasks out)
- Docs (markdown notes attached to projects)

## Stack

- Next.js 14 (app router)
- Supabase (Postgres + auth)
- Tailwind + shadcn/ui
- Anthropic API for the AI meeting note summarizer
- Optional: Whisper API or local whisper.cpp for transcription

## What you need

| Thing | Where |
|---|---|
| Node 20+ | `brew install node` |
| Supabase account | https://supabase.com — free tier is fine for personal use |
| Anthropic API key | https://console.anthropic.com — pay per token |
| (Optional) OpenAI API key | For Whisper transcription if you don't run it locally |

## Recipe

Since this isn't a published repo, the path is: **build it yourself with Claude as the engineer.**

### 1. Spin up the scaffold

```bash
cd ~/code
npx create-next-app@latest ctrl-motion-lite --typescript --tailwind --app
cd ctrl-motion-lite
npx shadcn-ui@latest init
```

### 2. Wire Supabase

```bash
npm install @supabase/supabase-js @supabase/ssr
```

Create a Supabase project, then drop these env vars into `.env.local`:

```
NEXT_PUBLIC_SUPABASE_URL=https://YOUR-PROJECT.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...
ANTHROPIC_API_KEY=sk-ant-...
```

### 3. Schema

In Supabase SQL editor:

```sql
create table workspaces (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  owner_id uuid references auth.users(id),
  created_at timestamptz default now()
);

create table projects (
  id uuid primary key default gen_random_uuid(),
  workspace_id uuid references workspaces(id) on delete cascade,
  name text not null,
  description text,
  status text default 'active',
  created_at timestamptz default now()
);

create table tasks (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references projects(id) on delete cascade,
  title text not null,
  notes text,
  status text default 'todo', -- todo / in_progress / done
  priority int default 0,
  due_at timestamptz,
  created_at timestamptz default now()
);

create table docs (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references projects(id) on delete cascade,
  title text not null,
  content_md text,
  created_at timestamptz default now()
);

create table meeting_notes (
  id uuid primary key default gen_random_uuid(),
  project_id uuid references projects(id) on delete set null,
  transcript text,
  summary text,
  action_items jsonb,
  duration_seconds int,
  created_at timestamptz default now()
);
```

Add RLS policies — simplest version, "user can read/write their own workspaces":

```sql
alter table workspaces enable row level security;
create policy "own workspaces" on workspaces using (owner_id = auth.uid());
-- repeat shape for projects/tasks/docs/meeting_notes joining through workspace_id
```

### 4. Hand the rest to Claude Code

In your new project dir, drop a `CLAUDE.md`:

```markdown
# your CRM Lite

Local app: projects + tasks + meeting notes.

Stack: Next 14 app router, Supabase, Tailwind, shadcn/ui, Anthropic API.

Conventions:
- All DB calls go through src/lib/supabase/server.ts (server) or client.ts (client)
- Use server actions for mutations, not API routes
- No auth bypass — every query is RLS-scoped to auth.uid()
- Status colors: todo=gray, in_progress=amber, done=sage

Build order:
1. Auth (Supabase auth UI, magic link)
2. Workspaces page (list + create)
3. Projects page (per workspace, list + create + detail)
4. Tasks (kanban board on project detail, drag between columns)
5. Docs (markdown editor with mdx preview)
6. Meeting notes (paste transcript → call Anthropic to summarize → save)
```

Then iteratively prompt Claude:

> "Build the auth flow first. Use Supabase magic-link auth. After login, redirect to /workspaces. Match the design conventions in CLAUDE.md."

> "Now add the projects list page. Server component, RLS-filtered query, link to /projects/[id]."

> "Add the kanban board. Three columns: todo / in_progress / done. Drag with @dnd-kit/core."

> "Now meeting notes — paste a transcript, hit Summarize, call Anthropic with a prompt that returns `{summary, action_items: [{title, priority}]}`. Save both to the row, render summary as markdown, show action items as a checklist."

The `2-agents/` bundle is useful here — let `marcus` plan the data layer, `ricky` write the empty-state copy, `qc` review the build before you ship.

## AI meeting notes — the Anthropic call

Pattern we use:

```typescript
import Anthropic from '@anthropic-ai/sdk';

const client = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

const response = await client.messages.create({
  model: 'claude-sonnet-4-6',
  max_tokens: 4096,
  messages: [{
    role: 'user',
    content: `Summarize this meeting transcript and extract action items.

Return JSON: { "summary": "2-3 sentence summary", "action_items": [{"title": "...", "owner": "...", "priority": 1-3}] }

Transcript:
${transcript}`
  }]
});

const { summary, action_items } = JSON.parse(response.content[0].text);
```

For transcription (audio in → text), use OpenAI's Whisper API or run whisper.cpp locally:

```bash
# whisper.cpp local
brew install whisper-cpp
whisper-cli -m models/ggml-base.en.bin -f meeting.wav -otxt
```

## Why we didn't ship a code bundle

- The full your CRM is a 100K-LOC client CRM with deep integrations (GHL, Square, Meta, ad platforms). Stripping it down to "lite" without leaking client data would take more engineering than just rebuilding the smaller version.
- The recipe above gets you to "working app with Claude as the engineer" in ~3 hours.
- If you want to see the upstream architecture for inspiration, the patterns we use (server actions, RLS-everywhere, shadcn primitives, kanban with dnd-kit) are standard — any recent Next + Supabase tutorial covers them.

## Caveats

- **Don't reuse our DB schema in production without RLS** — the schema above is starter material. Audit policies before exposing the app to multiple users.
- **Anthropic API costs add up on long transcripts** — 1hr meeting = ~10K tokens in, ~1K out = roughly $0.04 per meeting on Sonnet. Cheap for personal use, but cap it if you open the app to clients.
- **Supabase free tier pauses after 7 days inactive** — fine for personal projects, not for production.
