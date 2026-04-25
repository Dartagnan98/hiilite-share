#!/usr/bin/env bash
# Brand Voice / iMessage — draft a single reply to a person, in the user's voice.
# Reads recent inbound + outbound + brand-voice.md, asks Claude for ONE reply,
# prints to stdout. The user reviews and runs send.sh manually if they like it.
#
# Usage: draft-reply.sh <person>
#   <person> matches a folder name under ~/.brand-voice/inbound/ and ~/.brand-voice/comms/

set -euo pipefail

ROOT="$HOME/.brand-voice"
PERSON="${1:-}"
[ -n "$PERSON" ] || { echo "Usage: $0 <person>" >&2; exit 1; }

INBOUND_DIR="$ROOT/inbound/$PERSON"
OUT_DIR="$ROOT/comms/$PERSON"
[ -d "$INBOUND_DIR" ] || { echo "No inbound folder for '$PERSON'. Run pull-inbound.sh first." >&2; exit 1; }

# Resolve API key
if [ -z "${ANTHROPIC_API_KEY:-}" ] && [ -f "$ROOT/.env" ]; then
  set -a; source "$ROOT/.env"; set +a
fi
[ -n "${ANTHROPIC_API_KEY:-}" ] || { echo "ANTHROPIC_API_KEY not set." >&2; exit 1; }

TMP=$(mktemp); trap 'rm -f "$TMP" "$TMP.req" "$TMP.resp"' EXIT

# Last 7 days of inbound and outbound, newest first, capped
{
  echo "## Recent inbound from $PERSON"
  echo
  find "$INBOUND_DIR" -type f -name '*.md' 2>/dev/null \
    | xargs -I{} stat -f '%m %N' "{}" 2>/dev/null \
    | sort -rn | head -7 | awk '{ $1=""; sub(/^ /,""); print }' \
    | while read -r f; do echo "### $(basename "$f" .md)"; cat "$f"; echo; done

  if [ -d "$OUT_DIR" ]; then
    echo
    echo "## Recent outbound to $PERSON (the user's prior replies — match this voice)"
    echo
    find "$OUT_DIR" -type f -name '*.md' 2>/dev/null \
      | xargs -I{} stat -f '%m %N' "{}" 2>/dev/null \
      | sort -rn | head -7 | awk '{ $1=""; sub(/^ /,""); print }' \
      | while read -r f; do echo "### $(basename "$f" .md)"; cat "$f"; echo; done
  fi
} > "$TMP"

GUARDRAILS=""
[ -f "$ROOT/brand-voice.md" ] && GUARDRAILS=$(cat "$ROOT/brand-voice.md")

python3 - "$TMP" "$GUARDRAILS" "$PERSON" > "$TMP.req" <<'PY'
import json,sys
ctx, guardrails, person = open(sys.argv[1]).read(), sys.argv[2], sys.argv[3]
system = f"""You are drafting a single iMessage reply on behalf of the user, to {person}.

{guardrails}

Output ONE message only — no greeting, no signoff, no quoted text, no commentary, no "here's a draft:". Just the message body the user would actually send. Keep it the length the user typically sends to this person (use the recent outbound as the length cue).
"""
user = f"""Recent context:

{ctx}

Draft a reply now."""
print(json.dumps({
  "model": "claude-sonnet-4-6",
  "max_tokens": 600,
  "system": system,
  "messages": [{"role":"user","content":user}],
}))
PY

curl -sf -X POST https://api.anthropic.com/v1/messages \
  -H "Content-Type: application/json" \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  --data @"$TMP.req" \
  -o "$TMP.resp" || { echo "Anthropic call failed."; cat "$TMP.resp" 2>/dev/null; exit 1; }

python3 -c "
import json,sys
d=json.load(open('$TMP.resp'))
print(''.join(b.get('text','') for b in d.get('content',[]) if b.get('type')=='text').strip())
"
