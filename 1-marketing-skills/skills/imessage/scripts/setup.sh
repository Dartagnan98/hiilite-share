#!/usr/bin/env bash
# Brand Voice — first-time setup
# Creates ~/.brand-voice/, prompts for an Anthropic API key, and seeds contacts.json.
# Optionally installs a daily LaunchAgent that re-pulls iMessage and re-analyzes voice.

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="$HOME/.brand-voice"

echo "Setting up Brand Voice in $ROOT"
mkdir -p "$ROOT/comms" "$ROOT/samples"

# 1. Anthropic API key
KEY_FILE="$ROOT/.env"
if [ ! -f "$KEY_FILE" ]; then
  if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
    echo "Picking up ANTHROPIC_API_KEY from environment."
    echo "ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY" > "$KEY_FILE"
  else
    echo
    echo "Paste your Anthropic API key (starts with sk-ant-...). It's saved to $KEY_FILE and read locally."
    read -r -s -p "ANTHROPIC_API_KEY: " key
    echo
    if [ -z "$key" ]; then
      echo "No key provided. Skipping. Set ANTHROPIC_API_KEY later or re-run setup."
    else
      echo "ANTHROPIC_API_KEY=$key" > "$KEY_FILE"
      chmod 600 "$KEY_FILE"
      echo "Saved."
    fi
  fi
else
  echo "Found existing API key at $KEY_FILE — leaving as-is."
fi

# 2. Contacts mapping
CONTACTS="$ROOT/contacts.json"
if [ ! -f "$CONTACTS" ]; then
  cp "$SKILL_DIR/contacts.example.json" "$CONTACTS"
  echo
  echo "Seeded $CONTACTS — open it and replace the example numbers with the people you message most."
  echo "Format: \"+15551234567\": \"alex\"  (E.164 phone or email → short lowercase folder name)"
fi

# 3. Optional LaunchAgent for daily refresh
echo
read -r -p "Install a daily LaunchAgent that pulls iMessage + re-analyzes voice at 2am? [y/N] " install_la
if [[ "$install_la" =~ ^[Yy]$ ]]; then
  PLIST="$HOME/Library/LaunchAgents/com.brandvoice.daily.plist"
  cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.brandvoice.daily</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>-c</string>
    <string>$SKILL_DIR/scripts/pull-imessage.sh --days 7 &amp;&amp; $SKILL_DIR/scripts/analyze.sh</string>
  </array>
  <key>StartCalendarInterval</key>
  <dict><key>Hour</key><integer>2</integer><key>Minute</key><integer>0</integer></dict>
  <key>StandardOutPath</key><string>$ROOT/launchd.log</string>
  <key>StandardErrorPath</key><string>$ROOT/launchd.log</string>
</dict>
</plist>
EOF
  launchctl unload "$PLIST" 2>/dev/null || true
  launchctl load "$PLIST"
  echo "LaunchAgent installed. Logs: $ROOT/launchd.log"
else
  echo "Skipping LaunchAgent. You can re-run setup later or run pull-imessage.sh + analyze.sh manually."
fi

echo
echo "Setup done."
echo
echo "Next steps:"
echo "  1. Edit $CONTACTS to add your real contacts."
echo "  2. Grant Terminal (or your shell app) Full Disk Access:"
echo "     System Settings → Privacy & Security → Full Disk Access → add Terminal/iTerm/VS Code."
echo "  3. Run: bash $SKILL_DIR/scripts/pull-imessage.sh --days 90"
echo "  4. Run: bash $SKILL_DIR/scripts/analyze.sh"
echo "  5. Voice file lives at $ROOT/brand-voice.md — every other marketing skill picks it up automatically."
