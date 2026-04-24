#!/bin/bash
# Telegram watchdog -- monitors tmux Claude session and sends
# periodic status updates so the user sees what's happening.
#
# Shows the current tool/phase + elapsed time, updated every 15s.
# Example: "⚙️ Bash (searching vault files) — 1m 30s"
# Deletes the status message when Claude goes idle.

SESSION="agent-session"
source "$HOME/agent-session/.env" 2>/dev/null
TOKEN="${TELEGRAM_BOT_TOKEN}"
CHAT_ID="${YOUR_TELEGRAM_CHAT_ID}"
CHECK_INTERVAL=10
# Send first status message after this many seconds of work
FIRST_UPDATE_DELAY=20

if [ -z "$TOKEN" ]; then
  echo "No TELEGRAM_BOT_TOKEN found" >&2
  exit 1
fi

send_typing() {
  curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendChatAction" \
    -H "Content-Type: application/json" \
    -d "{\"chat_id\":\"${CHAT_ID}\",\"action\":\"typing\"}" > /dev/null 2>&1
}

send_message() {
  local text="$1"
  curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
    -H "Content-Type: application/json" \
    -d "{\"chat_id\":\"${CHAT_ID}\",\"text\":\"${text}\",\"disable_notification\":true}" 2>/dev/null | \
    python3 -c "import sys,json; print(json.load(sys.stdin).get('result',{}).get('message_id',''))" 2>/dev/null
}

edit_message() {
  local msg_id="$1"
  local text="$2"
  curl -s -X POST "https://api.telegram.org/bot${TOKEN}/editMessageText" \
    -H "Content-Type: application/json" \
    -d "{\"chat_id\":\"${CHAT_ID}\",\"message_id\":${msg_id},\"text\":\"${text}\"}" > /dev/null 2>&1
}

delete_message() {
  local msg_id="$1"
  curl -s -X POST "https://api.telegram.org/bot${TOKEN}/deleteMessage" \
    -H "Content-Type: application/json" \
    -d "{\"chat_id\":\"${CHAT_ID}\",\"message_id\":${msg_id}}" > /dev/null 2>&1
}

# Escape text for JSON string
json_escape() {
  echo "$1" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read().strip())[1:-1])" 2>/dev/null
}

get_pane_content() {
  tmux capture-pane -t "$SESSION" -p -S -40 2>/dev/null
}

is_claude_working() {
  local pane="$1"

  # Idle: prompt line anywhere in last 8 lines (statusline renders below it)
  if echo "$pane" | tail -8 | grep -q "^❯"; then
    return 1
  fi

  # Idle: "Waiting on" message
  if echo "$pane" | tail -8 | grep -q "Waiting on"; then
    return 1
  fi

  # Active: spinner/phase indicators
  if echo "$pane" | tail -15 | grep -qE "Running|Thinking|Ideating|Crunching|Ebbing|Streaming|Swooping|Sautéed|Cooked|Baked|Churned|thought for|✻|✽|✢|◐"; then
    return 0
  fi

  # Active: tool use in progress
  if echo "$pane" | tail -15 | grep -qE "⏺.*Bash|⏺.*Read|⏺.*Edit|⏺.*Write|⏺.*Grep|⏺.*Glob|⏺.*Agent|⏺.*plugin:|⏺.*mcp"; then
    return 0
  fi

  return 1
}

# Parse what Claude is currently doing from the tmux pane
get_current_activity() {
  local pane="$1"

  # Phase indicator (Ideating, Crunching, Ebbing, Streaming, etc.)
  local phase
  phase=$(echo "$pane" | grep -oE "(Ideating|Crunching|Thinking|Ebbing|Streaming|Planning)" | tail -1)

  # Built-in timer from Claude (e.g. "thought for 3s", "6m 21s")
  local claude_timer
  claude_timer=$(echo "$pane" | grep -oE "[0-9]+m [0-9]+s|[0-9]+s" | tail -1)

  # Current tool being used
  local tool
  tool=$(echo "$pane" | tail -20 | grep -oE "⏺ (Bash|Read|Edit|Write|Grep|Glob|Agent|plugin:[^ ]+|mcp[^ ]+)" | tail -1 | sed 's/⏺ //')

  # Tool description -- the bit in parens or after the tool name
  local tool_desc=""
  if [ -n "$tool" ]; then
    # Try to get the command/description after the tool name
    local tool_line
    tool_line=$(echo "$pane" | tail -20 | grep "⏺.*${tool}" | tail -1)
    # Extract parenthetical description like "Bash(cd ${PROJECT_DIR} && ...)"
    tool_desc=$(echo "$tool_line" | grep -oE "\(.*" | head -1 | cut -c1-60)
    if [ ${#tool_desc} -ge 60 ]; then
      tool_desc="${tool_desc}..."
    fi
  fi

  # Agent subagent description
  local agent_desc=""
  if [ "$tool" = "Agent" ]; then
    agent_desc=$(echo "$pane" | tail -20 | grep -oE "Agent\(.*\)" | tail -1 | sed 's/Agent(//' | sed 's/)//' | cut -c1-40)
  fi

  # Running... indicator
  local running=""
  if echo "$pane" | tail -10 | grep -q "Running"; then
    running="running"
  fi

  # Token count
  local token_info
  token_info=$(echo "$pane" | grep -oE "↓ [0-9.]+k tokens" | tail -1)

  # Build the status line
  local status=""

  if [ -n "$phase" ]; then
    status="$phase"
    if [ -n "$claude_timer" ]; then
      status="$status ($claude_timer)"
    fi
  fi

  if [ -n "$tool" ]; then
    if [ -n "$status" ]; then
      status="$status | $tool"
    else
      status="$tool"
    fi
    if [ -n "$agent_desc" ]; then
      status="$status: $agent_desc"
    elif [ -n "$tool_desc" ]; then
      status="$status$tool_desc"
    fi
    if [ -n "$running" ]; then
      status="$status ⏳"
    fi
  fi

  if [ -n "$token_info" ]; then
    if [ -n "$status" ]; then
      status="$status | $token_info"
    else
      status="$token_info"
    fi
  fi

  # Fallback
  if [ -z "$status" ]; then
    status="processing"
  fi

  echo "$status"
}

format_elapsed() {
  local elapsed=$1
  local mins=$((elapsed / 60))
  local secs=$((elapsed % 60))
  if [ "$mins" -gt 0 ]; then
    echo "${mins}m ${secs}s"
  else
    echo "${secs}s"
  fi
}

working_since=0
status_msg_id=""
last_status_text=""

while true; do
  if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    sleep "$CHECK_INTERVAL"
    continue
  fi

  pane=$(get_pane_content)

  if is_claude_working "$pane"; then
    now=$(date +%s)

    if [ "$working_since" -eq 0 ]; then
      working_since=$now
      send_typing
    fi

    elapsed=$((now - working_since))
    send_typing

    # After initial delay, start showing status
    if [ "$elapsed" -ge "$FIRST_UPDATE_DELAY" ]; then
      activity=$(get_current_activity "$pane")
      time_str=$(format_elapsed $elapsed)
      text="⚙️ ${activity} — ${time_str}"

      # Only send/edit if text changed (avoid Telegram rate limits on identical edits)
      if [ "$text" != "$last_status_text" ]; then
        escaped_text=$(json_escape "$text")
        if [ -z "$status_msg_id" ]; then
          status_msg_id=$(send_message "$escaped_text")
        else
          edit_message "$status_msg_id" "$escaped_text"
        fi
        last_status_text="$text"
      fi
    fi
  else
    # Claude is idle
    if [ "$working_since" -ne 0 ]; then
      if [ -n "$status_msg_id" ]; then
        delete_message "$status_msg_id"
        status_msg_id=""
      fi
      working_since=0
      last_status_text=""
    fi
  fi

  sleep "$CHECK_INTERVAL"
done
