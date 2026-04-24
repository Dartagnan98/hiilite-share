#!/usr/bin/env bash
# Extracts conversation, task, and system context for the heartbeat
# Usage: heartbeat-context.sh [hours_back]
# Morning calls this with 168 (7 days), midday/EOD with 6

set -euo pipefail

DB="$HOME/agent-session/store/agent-session.db"
PROJECT_DIR="$HOME/agent-session"
HOURS="${1:-12}"
CUTOFF=$(date -v-${HOURS}H +%s 2>/dev/null || date -d "-${HOURS} hours" +%s)
DAYS=$((HOURS / 24))
[ "$DAYS" -lt 1 ] && DAYS=1

AGENT_LOG="$PROJECT_DIR/scripts/agent_log.py"

# ============================================================
# 0a. PRIOR HEARTBEAT HANDOFF (continuity across runs)
# ============================================================
# The #1 complaint about the old heartbeat: "gives me updates but doesn't do
# anything." This section exists so each new run reads the prior run's summary
# + its actions + its unresolved stuck items -- so the next run picks up where
# the last one left off instead of restarting cold.
echo "=== PRIOR HEARTBEAT HANDOFF ==="
if [ -x "$AGENT_LOG" ]; then
  echo ""
  echo "--- Last 3 heartbeat runs (newest first) ---"
  "$AGENT_LOG" recent-runs --limit 3 --full 2>/dev/null || echo "(agent_log read failed)"

  echo ""
  echo "--- Actions taken since last heartbeat (last ${HOURS}h, agent=heartbeat) ---"
  "$AGENT_LOG" recent-actions --since "${HOURS}h" --agent heartbeat --limit 100 2>/dev/null || echo "(none)"

  echo ""
  echo "--- Pending drafts (awaiting approval) ---"
  "$AGENT_LOG" pending-drafts 2>/dev/null || echo "(none)"
else
  echo "(agent_log.py not executable at $AGENT_LOG -- continuity disabled)"
fi

# ============================================================
# 0b. GRAPHIFY KNOWLEDGE GRAPH (replaces Mem0 + LightRAG)
# ============================================================
echo ""
echo "=== KNOWLEDGE GRAPH CONTEXT ==="

# Pull recent session summaries from knowledge/sessions
echo ""
echo "--- Recent Sessions ---"
for f in $(ls -t "$PROJECT_DIR/knowledge/sessions/"*.md 2>/dev/null | head -$DAYS); do
  echo "$(basename "$f" .md):"
  head -5 "$f" 2>/dev/null
  echo ""
done

# Pull recent comms digests
echo ""
echo "--- Recent Comms ---"
for client_dir in "$PROJECT_DIR/knowledge/comms"/*/; do
  if [ -d "$client_dir" ]; then
    client=$(basename "$client_dir")
    latest=$(ls -t "$client_dir"*.md 2>/dev/null | head -1)
    if [ -n "$latest" ]; then
      echo "$client ($(basename "$latest" .md)):"
      head -3 "$latest" 2>/dev/null
      echo ""
    fi
  fi
done

# ============================================================
# 1. CONVERSATIONS (iMessage + WhatsApp from SQLite)
# ============================================================
echo "=== CONVERSATIONS (last ${HOURS}h) ==="

echo ""
echo "--- iMessage ---  (format: [time] SENDER -> RECIPIENT: content)"
sqlite3 -separator ' ' "$DB" "
  SELECT
    '[' || strftime('%m-%d %H:%M', timestamp, 'unixepoch', 'localtime') || ']',
    CASE WHEN is_from_me = 1 THEN 'Operator -> ' || contact_name ELSE contact_name || ' -> Operator' END,
    ':',
    content
  FROM imessage_messages
  WHERE timestamp > $CUTOFF AND content != ''
  ORDER BY timestamp DESC
  LIMIT 300
" 2>/dev/null || echo "(no data)"

echo ""
echo "--- WhatsApp ---  (format: [time] SENDER -> RECIPIENT: content)"
sqlite3 -separator ' ' "$DB" "
  SELECT
    '[' || strftime('%m-%d %H:%M', timestamp, 'unixepoch', 'localtime') || ']',
    CASE WHEN is_from_me = 1 THEN 'Operator -> ' || contact_name ELSE contact_name || ' -> Operator' END,
    ':',
    content
  FROM wa_messages
  WHERE timestamp > $CUTOFF AND content != ''
  ORDER BY timestamp DESC
  LIMIT 300
" 2>/dev/null || echo "(no data)"

# ============================================================
# 2. GIT HISTORY (what shipped)
# ============================================================
echo ""
echo "=== GIT HISTORY (last ${DAYS} days) ==="
cd "$PROJECT_DIR"
git log --oneline --since="${DAYS} days ago" --no-merges 2>/dev/null | head -40 || echo "(no commits)"

if [ -d "$PROJECT_DIR/app/.git" ]; then
  echo ""
  echo "--- app/ repo ---"
  cd "$PROJECT_DIR/app"
  git log --oneline --since="${DAYS} days ago" --no-merges 2>/dev/null | head -20 || echo "(no commits)"
  cd "$PROJECT_DIR"
fi

# ============================================================
# 3. CLIENT WORK COMPLETED
# ============================================================
echo ""
echo "=== CLIENT WORK LOG ==="
for f in "$PROJECT_DIR"/knowledge/clients/*/tasks-completed.md; do
  if [ -f "$f" ]; then
    client=$(basename "$(dirname "$f")")
    echo "--- $client ---"
    tail -30 "$f" 2>/dev/null
    echo ""
  fi
done

# ============================================================
# 4. TODO.MD + LESSONS.MD (current working state)
# ============================================================
echo ""
echo "=== TODO.MD ==="
cat "$PROJECT_DIR/tasks/todo.md" 2>/dev/null || echo "(not found)"

echo ""
echo "=== LESSONS.MD (last 20 entries) ==="
tail -40 "$PROJECT_DIR/tasks/lessons.md" 2>/dev/null || echo "(not found)"
