#!/usr/bin/env bash
# Brand Voice / iMessage — pull inbound messages per-person per-day.
# Used by draft-reply.sh to give Claude fresh context before responding.
#
# Usage: pull-inbound.sh [--days N]   (default 7)

set -euo pipefail

ROOT="$HOME/.brand-voice"
CHAT_DB="$HOME/Library/Messages/chat.db"
CONTACTS="$ROOT/contacts.json"
DAYS=7

while [ $# -gt 0 ]; do
  case "$1" in
    --days) DAYS="$2"; shift 2 ;;
    -h|--help) sed -n '2,7p' "$0"; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

[ -f "$CHAT_DB" ] || { echo "iMessage DB not found at $CHAT_DB" >&2; exit 1; }
[ -f "$CONTACTS" ] || { echo "Contacts file missing — run setup.sh first" >&2; exit 1; }
command -v sqlite3 >/dev/null || { echo "sqlite3 not found" >&2; exit 1; }
command -v python3 >/dev/null || { echo "python3 not found (used to parse contacts.json)" >&2; exit 1; }

mkdir -p "$ROOT/inbound"

NOW_NS=$(python3 -c "import time; print(int((time.time()-978307200)*1e9))")
CUTOFF_NS=$(python3 -c "import time; print(int((time.time()-978307200-${DAYS}*86400)*1e9))")

# Stream contacts as "handle\tperson" lines (mapfile isn't in macOS bash 3.2,
# so write to a temp file and read it line-by-line).
CONTACT_LIST=$(mktemp)
trap 'rm -f "$CONTACT_LIST"' EXIT
python3 -c "
import json
with open('$CONTACTS') as f: c=json.load(f)
for k,v in c.items():
    if k.startswith('_'): continue
    print(f'{k}\t{v}')
" > "$CONTACT_LIST"

if [ ! -s "$CONTACT_LIST" ]; then
  echo "No contacts in $CONTACTS — add at least one." >&2
  exit 1
fi

TOTAL=0
while IFS=$'\t' read -r handle person; do
  [ -z "$handle" ] && continue
  PERSON_DIR="$ROOT/inbound/$person"
  mkdir -p "$PERSON_DIR"

  # Inbound only: is_from_me = 0
  ROWS=$(sqlite3 -separator $'\x1f' "file:${CHAT_DB}?mode=ro" "
    SELECT
      strftime('%Y-%m-%d', m.date/1000000000 + 978307200, 'unixepoch', 'localtime'),
      strftime('%H:%M', m.date/1000000000 + 978307200, 'unixepoch', 'localtime'),
      replace(replace(coalesce(m.text,''), char(10), ' '), char(13), ' ')
    FROM message m
    LEFT JOIN handle h ON m.handle_id = h.ROWID
    WHERE h.id = '$(printf '%s' "$handle" | sed "s/'/''/g")'
      AND m.is_from_me = 0
      AND m.text IS NOT NULL AND m.text != ''
      AND m.date BETWEEN $CUTOFF_NS AND $NOW_NS
    ORDER BY m.date ASC;
  " 2>&1) || { echo "Query failed for $handle: $ROWS" >&2; continue; }

  [ -z "$ROWS" ] && continue

  # Always rebuild inbound — it's "fresh context" for replies
  CURRENT_DATE=""
  CURRENT_FILE=""
  COUNT=0
  while IFS=$'\x1f' read -r d t txt; do
    [ -z "$d" ] && continue
    if [ "$d" != "$CURRENT_DATE" ]; then
      CURRENT_DATE="$d"
      CURRENT_FILE="$PERSON_DIR/$d.md"
      printf "# Inbound from %s — %s\n\n" "$person" "$d" > "$CURRENT_FILE"
    fi
    printf -- "- **%s** %s\n" "$t" "$txt" >> "$CURRENT_FILE"
    COUNT=$((COUNT+1))
  done <<< "$ROWS"

  echo "  $person: $COUNT inbound msgs"
  TOTAL=$((TOTAL+COUNT))
done < "$CONTACT_LIST"

echo
echo "Done. $TOTAL inbound messages → $ROOT/inbound/"
