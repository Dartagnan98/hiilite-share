---
name: apple-reminders
description: Read, create, update, complete, or delete reminders in macOS / iCloud Reminders.app. Use when the user mentions "reminder," "reminders," "to-do," "todo list," "Apple Reminders," "remind me," "add to my list," "Errands list," "Groceries list," "what's on my list," "tasks for today" (in a personal context, not project-management Asana sense), or names a specific Reminders list ("Hiilite," "Personal," etc.). Also use when user wants to bridge a captured item into their phone's reminder system so it surfaces via Siri / CarPlay / lock screen. Triggers on phrases like "remind me to," "add it to my reminders," "what reminders are due," "mark X as done," "create a Groceries list," "search my reminders for Y."
metadata:
  version: 1.0.0
  requires_mcp: apple-reminders
---

# Apple Reminders

You operate the user's macOS / iCloud Reminders.app via the `apple-reminders` MCP server. Reminders sync to iPhone, iPad, Mac, CarPlay, Siri.

## When to invoke

- Capture: "remind me to [thing]," "add [thing] to my list"
- Read: "what's on my list," "what's due today," "show me my Errands"
- Search: "do I have a reminder about [topic]"
- Update: "change due date on X," "move Y to the Personal list"
- Mark done: "I picked up the dry cleaning, mark it done"
- List management: "create a new list called Z," "delete the old [list]"

Do NOT invoke for:
- Asana-style team task management (use `paid-ads` or other PM tools, or surface via Motion Lite)
- Calendar events (those are MS365 calendar / Google Calendar, not reminders)
- Long-form notes (use Apple Notes or OneNote, not Reminders — Reminders are short, actionable items)

## Tool surface

| Tool | When |
|---|---|
| `list_lists` | First call when user references a list name and you don't know what lists exist. Caches across the session. |
| `list_reminders` | "What's on my [list]?" Default to incomplete-only. Pass `includeCompleted: true` only if user asks. |
| `search_reminders` | "Do I have a reminder about [keyword]?" Cross-list match. |
| `get_reminder` | Need full details (notes, due time, priority) — list_reminders gives summaries. |
| `create_reminder` | Capture. Always specify the list (default "Reminders" if user doesn't say). Set due date if user gave one. |
| `update_reminder` | Editing existing — change due, notes, priority, or move list. |
| `complete_reminder` | "Done with X." |
| `uncomplete_reminder` | "I marked that done by mistake." |
| `delete_reminder` | "Cancel that," "remove it" — confirms before firing on bulk deletes. |
| `create_list` | User explicitly asks for a new list. Don't create lists silently — ask first. |
| `delete_list` | Confirm clearly before firing — this nukes ALL reminders in the list. |

## Capture conventions

When creating a reminder:

1. **Pick a list deliberately.** If user says "remind me about X," ask which list IF you have no signal. Otherwise:
   - Personal life stuff → "Personal" or default Reminders
   - Errands / shopping → "Errands" or "Groceries"
   - Work / Hiilite stuff → "Hiilite" (only if that list exists)
   - When in doubt: ask. One-line question is faster than fixing the wrong list.

2. **Due dates: only when given.** Don't fabricate a "let's say tomorrow" — leave undated unless the user said when. Reminders without dates show in "All" or list view, which is fine.

3. **Notes field for context.** If the user is capturing while on a call or in conversation, dump the relevant context into `notes` so they don't have to remember why they captured it.

4. **Priority: rarely.** Apple's priority is a 1–9 scale that maps to Low/Medium/High flags. Skip unless the user explicitly says "high priority."

## Read conventions

When listing reminders:

- **Group by list** when showing >5 items.
- **Show due dates** in user's local format (e.g. "Tomorrow 3pm" not "2026-05-02T15:00:00Z").
- **Default to incomplete only.** Completed items are noise unless asked.
- **Limit to ~10** by default; offer "show all" if more exist.

## Sync timing

Changes via the MCP write to the local Reminders.app database, which then syncs to iCloud (~5–30 seconds). If the user asks "did it sync?" — give it 30s before retrying. CarPlay / Apple Watch sometimes lag a minute or two.

## Common mistakes to avoid

- Don't create new lists "preemptively" — only when the user asks.
- Don't bulk-set due dates on imported items unless user wants notifications. Each due date = one notification.
- Don't infer "complete" from past-tense statements ("I went to the store") without asking — they may have items they didn't yet do.
- If `AppleEvent timed out` errors — Automation permission isn't granted. Tell user to check System Settings → Privacy & Security → Automation → enable Reminders for Claude.

## Voice / tone

Reminders is personal. When you capture or report items, match the user's brand voice (see `~/.brand-voice/brand-voice.md`). Don't be clinical. "Added 'pick up dry cleaning' to your Errands list — due 5pm Saturday." beats "Reminder created with name 'pick up dry cleaning' in list 'Errands' with due_date 2026-05-03T17:00:00."
