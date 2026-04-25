#!/usr/bin/env bash
# Brand Voice / iMessage — send a real iMessage via the Messages app.
# Always confirm with the user before invoking. Sending is irreversible.
#
# Usage: send.sh <handle> <message...>
#   <handle>  phone in E.164 (e.g. +15551234567) or email
#   <message> the body to send (quote or pass remaining args)

set -euo pipefail

HANDLE="${1:-}"
shift || true
MSG="$*"

if [ -z "$HANDLE" ] || [ -z "$MSG" ]; then
  echo "Usage: $0 <handle> <message>" >&2
  exit 1
fi

# AppleScript send. Force iMessage service first; fall back to default if not signed in.
osascript <<EOF
tell application "Messages"
  set targetService to first service whose service type = iMessage
  set targetBuddy to buddy "$HANDLE" of targetService
  send "$(printf '%s' "$MSG" | sed 's/"/\\"/g')" to targetBuddy
end tell
EOF

echo "Sent → $HANDLE"
