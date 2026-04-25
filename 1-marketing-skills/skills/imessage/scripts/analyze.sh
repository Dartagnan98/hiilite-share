#!/usr/bin/env bash
# Brand Voice — read every comms + sample .md and produce ~/.brand-voice/brand-voice.md
# via Claude Sonnet 4.6. Requires ANTHROPIC_API_KEY (env or ~/.brand-voice/.env).

set -euo pipefail

ROOT="$HOME/.brand-voice"
OUT="$ROOT/brand-voice.md"
MAX_CHARS=120000  # ~30k tokens of recent material

[ -d "$ROOT/comms" ] || { echo "No comms folder. Run pull-imessage.sh first." >&2; exit 1; }

# Resolve API key
if [ -z "${ANTHROPIC_API_KEY:-}" ] && [ -f "$ROOT/.env" ]; then
  set -a; source "$ROOT/.env"; set +a
fi
[ -n "${ANTHROPIC_API_KEY:-}" ] || { echo "ANTHROPIC_API_KEY not set. Run setup.sh." >&2; exit 1; }
[[ "$ANTHROPIC_API_KEY" == sk-ant-* ]] || { echo "ANTHROPIC_API_KEY doesn't look like an Anthropic key (sk-ant-...)." >&2; exit 1; }

# Concat newest-first, cap at MAX_CHARS so we don't blow context.
TMP=$(mktemp)
trap 'rm -f "$TMP" "$TMP.req" "$TMP.resp"' EXIT

# All .md under comms/ and samples/, newest first by mtime
files=()
while IFS= read -r f; do files+=("$f"); done < <(
  find "$ROOT/comms" "$ROOT/samples" -type f -name '*.md' 2>/dev/null \
    | xargs -I{} stat -f '%m %N' "{}" 2>/dev/null \
    | sort -rn \
    | awk '{ $1=""; sub(/^ /,""); print }'
)

if [ ${#files[@]} -eq 0 ]; then
  echo "No .md files under $ROOT/comms or $ROOT/samples — nothing to analyze." >&2
  exit 1
fi

CHARS=0
SAMPLES_USED=0
for f in "${files[@]}"; do
  SIZE=$(wc -c < "$f")
  REMAINING=$((MAX_CHARS - CHARS))
  [ "$REMAINING" -le 0 ] && break
  if [ "$SIZE" -le "$REMAINING" ]; then
    cat "$f" >> "$TMP"
    printf "\n\n---\n\n" >> "$TMP"
    CHARS=$((CHARS + SIZE + 7))
  else
    head -c "$REMAINING" "$f" >> "$TMP"
    CHARS=$MAX_CHARS
  fi
  SAMPLES_USED=$((SAMPLES_USED+1))
done

WORDS=$(wc -w < "$TMP" | tr -d ' ')
echo "Analyzing $SAMPLES_USED samples ($WORDS words) ..."

# Build the request body. heredoc writes JSON via python to safely escape.
python3 - "$TMP" > "$TMP.req" <<'PY'
import json,sys
sample = open(sys.argv[1]).read()
system = """You analyze writing samples and extract structured voice guardrails. Return JSON only — no preamble, no commentary, no markdown fences.

Schema:
{
  "tone_words": string[],     // 3-7 single words capturing the FEEL of the writing (e.g. "direct", "warm", "skeptical")
  "do_words": string[],       // 5-12 words/short phrases the writer actually uses or would use
  "avoid_words": string[],    // 5-12 words/phrases NOT in this voice — generic AI filler the writer would never say
  "style_rules": string[],    // 4-8 operational rules (one per line, in imperative form, e.g. "Lead with the result, not the setup.")
  "rationale": string         // 1-2 sentence summary of what makes this voice distinct
}"""
user = f"""Writing samples (concatenated, newest first):
\"\"\"
{sample}
\"\"\"

Extract the voice guardrails. JSON only."""
print(json.dumps({
  "model": "claude-sonnet-4-6",
  "max_tokens": 2000,
  "system": system,
  "messages": [{"role": "user", "content": user}],
}))
PY

curl -sf -X POST https://api.anthropic.com/v1/messages \
  -H "Content-Type: application/json" \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  --data @"$TMP.req" \
  -o "$TMP.resp" || { echo "Anthropic call failed."; cat "$TMP.resp" 2>/dev/null; exit 1; }

# Parse response → write brand-voice.md
python3 - "$TMP.resp" "$OUT" "$SAMPLES_USED" "$WORDS" <<'PY'
import json,sys,re,datetime
resp = json.load(open(sys.argv[1]))
out_path, samples, words = sys.argv[2], sys.argv[3], sys.argv[4]
text = ''.join(b.get('text','') for b in resp.get('content',[]) if b.get('type')=='text')
m = re.search(r'\{.*\}', text, re.S)
if not m:
    sys.exit(f"No JSON in response:\n{text[:400]}")
data = json.loads(m.group(0))
def lst(k): return data.get(k) or []
today = datetime.date.today().isoformat()
md = [f"# Brand Voice", "",
      f"> Generated on {today} from {samples} writing samples ({words} words analyzed).", "",
      "## Rationale", data.get('rationale','').strip() or "(none)", "",
      "## Tone"] + [f"- {w}" for w in lst('tone_words')] + ["",
      "## Do words"] + [f"- {w}" for w in lst('do_words')] + ["",
      "## Avoid words"] + [f"- {w}" for w in lst('avoid_words')] + ["",
      "## Style rules"] + [f"- {w}" for w in lst('style_rules')] + [""]
open(out_path,'w').write("\n".join(md))
print(f"Wrote {out_path}")
PY

echo
echo "Voice file ready. Every other marketing skill in this bundle reads it automatically before generating copy."
