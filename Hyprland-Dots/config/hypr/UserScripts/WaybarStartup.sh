#!/bin/bash
# Start Waybar and apply persisted state (hidden/visible)

# Kill any running waybar instances first to ensure clean start
pkill waybar
sleep 0.5

# Start waybar in background
waybar &
WAYBAR_PID=$!

# Wait for it to initialize
sleep 2

STATE_FILE="$HOME/.config/hypr/waybar_state"

if [ -f "$STATE_FILE" ]; then
    STATE=$(cat "$STATE_FILE")
    if [ "$STATE" == "hidden" ]; then
        # If state is hidden, send signal to hide it
        # (Waybar starts visible by default)
        kill -SIGUSR1 $WAYBAR_PID
    fi
fi
