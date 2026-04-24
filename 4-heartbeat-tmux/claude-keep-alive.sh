#!/bin/bash
# Keep Claude Code running in a tmux session
# Restarts automatically if it exits
# LaunchAgent KeepAlive re-runs this script if it exits

SESSION="agent-session"
WORKDIR="$HOME/agent-session"
CLAUDE="$HOME/.local/bin/claude"

# If tmux session already exists, wait for it to die
if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "Session '$SESSION' already running, waiting..."
    while tmux has-session -t "$SESSION" 2>/dev/null; do
        sleep 10
    done
    echo "Session died, will recreate"
fi

# Kill any stale telegram plugin processes before starting.
# Multiple long-poll connections on the same bot token = messages get eaten by dead sessions.
pkill -f 'bun.*telegram.*start' 2>/dev/null
sleep 1

# Start a new tmux session running claude.
# We used to pass --plugin-dir to isolate telegram here, but that loads the
# plugin under the "inline" origin, which causes claude to silently skip
# channel notifications when --channels asks for plugin:telegram@claude-plugins-official
# (origin mismatch, debug log: "Channel notifications skipped ... installed ...
# from inline"). Drop --plugin-dir so the installed marketplace version loads
# and channel subscription matches. Multi-session poller conflicts are prevented
# by the SKIP_POLLING patch in server.ts (reapply-telegram-patch.py).
tmux new-session -d -s "$SESSION" -c "$WORKDIR" \
    "while true; do pkill -f 'bun.*telegram.*start' 2>/dev/null; sleep 1; $CLAUDE --channels plugin:telegram@claude-plugins-official; echo 'Claude exited, restarting in 5s...'; sleep 5; done"

echo "Started tmux session '$SESSION'"

# Stay alive while the tmux session exists
while tmux has-session -t "$SESSION" 2>/dev/null; do
    sleep 10
done

echo "Session '$SESSION' died, exiting so launchd restarts us"
exit 1
