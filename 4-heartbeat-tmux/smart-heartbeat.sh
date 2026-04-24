#!/usr/bin/env bash
# Smart Heartbeat -- 3x/day PROACTIVE agentic run.
# 6:30am -- Morning: 7-day review + plan the day + execute dropped balls.
# 1:00pm -- Midday check-in: catch drift, send follow-ups.
# 5:00pm -- EOD wrap: catch up unanswered threads, prep tomorrow.
#
# The old heartbeat was passive: "you should reply to Client C." The new heartbeat
# is agentic: it REPLIES to Client C, queues WA follow-ups, creates tasks. The
# Telegram briefing reports what WAS DONE, not what SHOULD BE DONE.
#
# Architecture:
#   1. agent_log run-start captures run_id
#   2. heartbeat-context.sh builds context file (prior run handoff + comms + git + todo)
#   3. claude --print runs with a prompt that wires in voice file + action primitives
#   4. Inside the run, Claude uses Bash to:
#        - imsg-send.sh / wa-send.sh for direct client replies (low-stakes)
#        - agent_log.py draft for high-stakes replies (awaiting approval)
#        - agent_log.py action for other work (task created, doc written)
#      Every action passes --run-id $RUN_ID.
#   5. Briefing is written to MSG_FILE. Stuck items to STUCK_FILE (JSON).
#   6. agent_log run-end folds it all into heartbeat_runs.

set -uo pipefail
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# CRITICAL: unset ANTHROPIC_API_KEY so `claude --print` falls back to the
# Claude Code subscription auth. When this env var is set (and invalid
# or rate-limited), claude exits immediately with "Invalid API key" and
# the whole heartbeat slot silently dies. Subscription auth is what we
# want anyway -- everything else on this Mac runs under the sub.
unset ANTHROPIC_API_KEY
unset ANTHROPIC_AUTH_TOKEN

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_DIR="$PROJECT_DIR/logs"
AGENT_LOG="$PROJECT_DIR/scripts/agent_log.py"
IMSG_SEND="$PROJECT_DIR/scripts/imsg-send.sh"
WA_SEND="$PROJECT_DIR/scripts/wa-send.sh"
VOICE_FILE="$HOME/.claude/projects/-USER/memory/feedback_voice.md"

TODAY=$(date +%Y-%m-%d)
DAY_OF_WEEK=$(date +%A)
HOUR=$(TZ="America/Los_Angeles" date +%H)
mkdir -p "$LOG_DIR"

# --- label + hours-back resolution ---
LABEL_OVERRIDE="${1:-}"
if [ -n "$LABEL_OVERRIDE" ]; then
  LABEL="$LABEL_OVERRIDE"
  if [ "$LABEL" = "Morning" ]; then HOURS_BACK=168; else HOURS_BACK=6; fi
elif [ "$HOUR" -lt 10 ]; then
  LABEL="Morning"
  HOURS_BACK=168
else
  if [ "$HOUR" -lt 15 ]; then
    LABEL="Midday"
  else
    LABEL="EOD"
  fi
  HOURS_BACK=6
fi
LABEL_LC=$(echo "$LABEL" | tr '[:upper:]' '[:lower:]')

# --- open the run FIRST so every action logged inside is linked to it ---
RUN_ID="$("$AGENT_LOG" run-start --label "$LABEL" 2>/dev/null || echo "")"
if [ -z "$RUN_ID" ]; then
  echo "[$TODAY $(date +%H:%M)] $LABEL heartbeat: agent_log run-start failed, aborting" >> "$LOG_DIR/smart-heartbeat.log"
  exit 1
fi
echo "[$TODAY $(date +%H:%M)] $LABEL heartbeat run_id=$RUN_ID started" >> "$LOG_DIR/smart-heartbeat.log"

# --- build context ---
CONTEXT_FILE="/tmp/heartbeat-context-${LABEL_LC}.txt"
"$SCRIPT_DIR/heartbeat-context.sh" "$HOURS_BACK" > "$CONTEXT_FILE" 2>/dev/null || true

# --- output + prompt files ---
MSG_FILE="/tmp/heartbeat-out-${LABEL_LC}.txt"
STUCK_FILE="/tmp/heartbeat-stuck-${LABEL_LC}.json"
PROMPT_FILE="/tmp/heartbeat-prompt-${LABEL_LC}.txt"
rm -f "$MSG_FILE" "$STUCK_FILE"

# --- voice file contents (paste verbatim into prompt) ---
VOICE_BODY=""
if [ -f "$VOICE_FILE" ]; then
  VOICE_BODY="$(cat "$VOICE_FILE")"
fi

# --- label-specific framing ---
if [ "$LABEL" = "Morning" ]; then
  TOMORROW=$(date -v+1d +%Y-%m-%d 2>/dev/null || date -d '+1 day' +%Y-%m-%d)
  FRAMING="This is the BIG briefing. You are looking at the full last 7 days. Nothing falls through the cracks. You will EXECUTE everything that can be executed before writing the report, then report on what was done."
  CALENDAR_BLOCK="Run: ctrlm calendar $TODAY
Run: ctrlm calendar $TOMORROW"
  OUTPUT_HEADER="Morning Brew -- $DAY_OF_WEEK $TODAY"
  OUTPUT_MAX=1600
else
  FRAMING="$LABEL check-in. Cross-reference last ${HOURS_BACK}h against prior heartbeat handoff. EXECUTE any pending action that should have happened since the last run. Then report."
  CALENDAR_BLOCK="Run: ctrlm calendar $TODAY"
  OUTPUT_HEADER="$LABEL -- $DAY_OF_WEEK $TODAY"
  OUTPUT_MAX=1100
fi

# --- build the prompt ---
cat > "$PROMPT_FILE" <<PROMPT_EOF
SCHEDULED AGENTIC HEARTBEAT: $LABEL -- $DAY_OF_WEEK $TODAY
run_id=$RUN_ID

## Your job

$FRAMING

You are Jimmy. You act on Operator's behalf. When you see a dropped ball (an
unanswered client message, a promise that wasn't kept, a stuck ad account), you
DO something about it -- you don't write "Operator should reply to Client C", you
REPLY TO Client C using imsg-send.sh or wa-send.sh.

The test for success: at the end of this run, fewer things should be stuck than
when the run started. If the briefing reads like a to-do list for Operator,
you failed. If it reads like a summary of what YOU did on his behalf, you won.

## Identity + voice

When you send messages as Operator, match his real voice. This is the
authoritative voice file -- read it now:

---BEGIN VOICE FILE---
$VOICE_BODY
---END VOICE FILE---

Before sending ANY message to a client, reread the "Examples of what to send"
section. Match lowercase, fragments, "all good", "no prob", "lmk". No
exclamation marks unless genuinely hyped. Typos are fine. Never AI-sounding.

## Action primitives (Bash tools)

You have FULL Bash access. Use these tools for outbound action:

**DRAFT-ONLY MODE: every outbound client message goes through $AGENT_LOG draft.
Operator approves/edits in real-time via Telegram inline buttons. Voice
tuning is in progress, so 0 auto-sends are allowed until further notice.
Do NOT call $IMSG_SEND or $WA_SEND directly from this heartbeat.**

1. **Create a DRAFT** (every client reply, regardless of stakes):
   $AGENT_LOG draft --channel imessage --recipient "<handle>" \\
     --content "<text>" --tier "<your-client-tags>" \\
     --reason "<short why>"
   (Use --channel whatsapp for WA.) Operator gets a Telegram notification
   with Approve / Edit / Trash buttons. On approval it sends automatically.

4. **Log any other action** (task created, doc updated, campaign paused, call
   scheduled, etc):
   $AGENT_LOG action --agent heartbeat --type "<kind>" \\
     --subject "<short label>" --details "<what happened>" \\
     --outcome ok --run-id $RUN_ID
   Use action types like: task_created, doc_updated, campaign_paused,
   campaign_scaled, lead_enriched, meeting_scheduled, blocker_escalated.

5. **your CRM** (ctrlm CLI -- tasks, calendar, ads, docs):
   ctrlm tasks              -- list open tasks
   ctrlm create-task ...    -- create a task (exact flags: ctrlm create-task --help)
   $CALENDAR_BLOCK
   ctrlm ads:dashboard      -- all accounts
   ctrlm doc:create "<title>"
   If you use ctrlm to actually change state (create a task, complete one),
   ALSO call agent_log action so it shows up in continuity.

## Guardrails

- 0 direct auto-sends. Every client message = DRAFT. No exceptions.
- Always include --tier so the voice-corrections log can track per-tier patterns:
    joe (friend tier, swearing ok, "bro"/"we got this" ok, dont stack slang)
    client A (your tone notes)
    client C (your tone notes)
    client D (your tone notes)
    other (default to professional)
- Before drafting, reread the voice file examples section. Lowercase, fragments,
  no em dashes, no exclamation stacking, no "Hi <name>!" openers.
- If you can't tell who the latest message is from (ambiguous direction), skip it.
- Never draft replies to handles with no prior conversation history. Flag as
  stuck_item instead.

## Message direction (CRITICAL)

Context file lines are: \`[time] SENDER -> RECIPIENT: content\`.
- \`Operator -> Client C: ...\` = Operator already sent this. Do NOT flag or
  reply again.
- \`Client C -> Operator: ...\` = Client C is waiting. This is the only case
  that means Operator owes a reply.
- Always check the LATEST message in a thread to decide who owes who.

## Data sources

### Source 1: Live systems (run these)
ctrlm tasks
$CALENDAR_BLOCK
ctrlm ads:dashboard
ctrlm docs
ctrlm clients

### Source 2: Context file (already built for you)
Read $CONTEXT_FILE -- it contains:
  - PRIOR HEARTBEAT HANDOFF: last 3 runs, their actions, stuck items
  - pending drafts awaiting approval
  - recent session summaries (knowledge/sessions)
  - recent comms digests
  - iMessage + WhatsApp last ${HOURS_BACK}h
  - git history last $((HOURS_BACK/24 + 1)) days
  - client work log + todo.md + lessons.md

START HERE. Read the handoff first. If the prior run flagged "reply to Doug"
as stuck, check if it's still stuck -- and if yes, DO it now.

## Workflow

1. INGEST: read $CONTEXT_FILE, skim ctrlm tasks + ctrlm ads:dashboard
2. EXECUTE: for each dropped ball / unanswered thread / prior stuck item:
   - Decide: direct send or draft (use guardrails above)
   - Take the action (imsg-send / wa-send / draft / task)
   - Record agent_log action row (auto-logged by wrappers)
3. REPORT: write to $MSG_FILE

## Report format (writes to $MSG_FILE)

Max $OUTPUT_MAX chars. Plain text, no code fences, no markdown headers
beyond the ones shown. First line must be the title line.

$OUTPUT_HEADER

DONE
- [2-5 bullets of what YOU actually executed this run -- "replied to Client C
  re financing link", "queued WA follow-up to Doug 10% off lead", "created
  task for Robert handoff Monday", "paused Animo tracking-broken campaign"]

ADS
- [short snapshot -- spend/leads/CPL per client, flag any 3x-Kill candidate]

CTRL MOTION
- [pull this from the live system, do not skip]
- Tasks: <open count> open, <overdue> overdue, <new since last heartbeat>
- Top priority: [1-3 highest-urgency task lines by priority, e.g.
    "#1232 Rerun Clifford CMA (p1, due today)" /
    "#1258 Relist Lewis Creek (p1, waiting on Client D)"]
- Dispatches: <queued>, <working>, <needs_review>. Flag any stuck > 24h.
  Run: ctrlm dispatch:list (or sqlite dispatch_queue on your-crm if cli missing)
- Calendar today: <meetings count + next meeting title/time>
- New docs/comms rolled in since last heartbeat: <yes/no + 1-line sample>
- Pipeline state: <any active pipeline runs? blocked steps?>

STILL NEEDS OPERATOR
- [ONLY what a human must do personally -- in-person meetings, money moves,
  high-stakes calls, anything you legitimately could not handle. If this
  section is empty, that's a GOOD sign.]

DRAFTS AWAITING APPROVAL
- [any drafts you queued this run -- "#47 imsg -> Joe re Academy pricing"]

Then write stuck items to $STUCK_FILE as a JSON array of short strings:
echo '["Client A: Animo pixel still broken day 2", "Client C: financing link not clicked"]' > $STUCK_FILE

## Tool restrictions

This session has NO Telegram MCP plugin. Do not attempt to call send_message
or any plugin:telegram tool. The shell wrapper delivers $MSG_FILE to Telegram
after you exit.

You DO have full Bash. Use it for imsg-send.sh, wa-send.sh, agent_log.py,
ctrlm, curl, sqlite3, anything.

When you finish, clean up: rm $CONTEXT_FILE
PROMPT_EOF

# --- run Claude synchronously with hard timeout ---
# Wrap in `timeout` so a hung claude --print can't block the next scheduled
# slot. 900s = 15min, generous ceiling. Exit 124 = SIGTERM from timeout,
# 137 = SIGKILL after the -k grace period. Either way the slot closes.
TIMEOUT_BIN="$(command -v timeout || command -v gtimeout || true)"
if [ -n "$TIMEOUT_BIN" ]; then
  "$TIMEOUT_BIN" -k 60 900 claude --print \
    -p "$(cat "$PROMPT_FILE")" \
    --dangerously-skip-permissions \
    > "$LOG_DIR/heartbeat-${LABEL_LC}-$TODAY.log" 2>&1
else
  claude --print \
    -p "$(cat "$PROMPT_FILE")" \
    --dangerously-skip-permissions \
    > "$LOG_DIR/heartbeat-${LABEL_LC}-$TODAY.log" 2>&1
fi

CLAUDE_STATUS=$?
echo "[$TODAY $(date +%H:%M)] $LABEL run_id=$RUN_ID claude exit=$CLAUDE_STATUS" >> "$LOG_DIR/smart-heartbeat.log"
if [ "$CLAUDE_STATUS" = "124" ] || [ "$CLAUDE_STATUS" = "137" ]; then
  echo "[$TODAY $(date +%H:%M)] $LABEL TIMED OUT after 15min -- slot closed by watchdog" >> "$LOG_DIR/smart-heartbeat.log"
fi

# --- deliver briefing ---
TG="$SCRIPT_DIR/tg-send.sh"
BRIEF_FILE=""
if [ -f "$MSG_FILE" ] && [ -s "$MSG_FILE" ]; then
  body=$(cat "$MSG_FILE")
  "$TG" --text "$body"
  echo "[$TODAY $(date +%H:%M)] $LABEL briefing sent (${#body} chars)" >> "$LOG_DIR/smart-heartbeat.log"

  # Archive for later lookup (Jimmy can Read this if follow-up needs detail)
  BRIEF_DIR="$PROJECT_DIR/knowledge/heartbeats"
  mkdir -p "$BRIEF_DIR"
  BRIEF_FILE="$BRIEF_DIR/$TODAY-$LABEL_LC.md"
  {
    echo "# $LABEL Heartbeat -- $DAY_OF_WEEK $TODAY (run_id=$RUN_ID)"
    echo
    cat "$MSG_FILE"
  } > "$BRIEF_FILE"

  # Inject pointer into the live jimmy session so it knows something happened
  ENV_FILE="$HOME/.claude/channels/telegram/.env"
  INJECT_TOKEN=""
  [ -f "$ENV_FILE" ] && INJECT_TOKEN=$(grep '^TELEGRAM_INJECT_TOKEN=' "$ENV_FILE" | cut -d= -f2-)

  if [ -n "$INJECT_TOKEN" ]; then
    ACTIONS_SUMMARY=$("$AGENT_LOG" recent-actions --since 30m --agent heartbeat --limit 20 2>/dev/null \
      | head -10 | tr '\n' ' | ' | cut -c1-400)
    POINTER="[heartbeat system notification] $LABEL agentic run complete (run_id=$RUN_ID). Briefing pushed to Telegram + archived at $BRIEF_FILE. Actions taken this run: ${ACTIONS_SUMMARY:-none}. Query more with: $AGENT_LOG recent-runs --limit 1 --full. Do not reply -- this is a system heads-up."
    INJECT_BODY=$(python3 -c 'import json,sys; print(json.dumps({"content": sys.argv[1], "user": "heartbeat", "chat_id": "heartbeat", "user_id": "0"}))' "$POINTER")
    curl -sS -X POST http://127.0.0.1:17991/inject \
      -H "x-inject-token: $INJECT_TOKEN" \
      -H "content-type: application/json" \
      -d "$INJECT_BODY" \
      >> "$LOG_DIR/smart-heartbeat.log" 2>&1 || true
    echo "[$TODAY $(date +%H:%M)] $LABEL pointer injected -> $BRIEF_FILE" >> "$LOG_DIR/smart-heartbeat.log"
  fi
else
  echo "[$TODAY $(date +%H:%M)] $LABEL no briefing file, nothing sent to telegram" >> "$LOG_DIR/smart-heartbeat.log"
fi

# --- close the run (folds in action counts + summary + stuck items) ---
# Use bash array to safely pass args (stuck-items JSON contains spaces + $-signs).
RUN_END_ARGS=(
  run-end
  --run-id "$RUN_ID"
  --exit "$CLAUDE_STATUS"
)
if [ -f "$MSG_FILE" ] && [ -s "$MSG_FILE" ]; then
  RUN_END_ARGS+=(--summary-file "$MSG_FILE")
fi
if [ -f "$STUCK_FILE" ] && [ -s "$STUCK_FILE" ]; then
  RUN_END_ARGS+=(--stuck-items-file "$STUCK_FILE")
fi

"$AGENT_LOG" "${RUN_END_ARGS[@]}" >> "$LOG_DIR/smart-heartbeat.log" 2>&1 \
  || echo "[$TODAY $(date +%H:%M)] $LABEL run_id=$RUN_ID run-end FAILED" >> "$LOG_DIR/smart-heartbeat.log"

echo "[$TODAY $(date +%H:%M)] $LABEL run_id=$RUN_ID closed" >> "$LOG_DIR/smart-heartbeat.log"
