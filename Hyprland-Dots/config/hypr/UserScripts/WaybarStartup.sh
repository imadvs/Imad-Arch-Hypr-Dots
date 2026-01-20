#!/bin/bash
# Start Waybar and apply persisted state (hidden/visible)

# Kill any running waybar instances first to ensure clean start
pkill waybar
sleep 0.5

# Start waybar in background
waybar &
WAYBAR_PID=$!

STATE_FILE="$HOME/.config/hypr/waybar_state"

if [ -f "$STATE_FILE" ]; then
    STATE=$(cat "$STATE_FILE")
    if [ "$STATE" == "hidden" ]; then
        # Wait a bit for Waybar to fully initialize to avoid crashing it
        sleep 1.0
        kill -SIGUSR1 $WAYBAR_PID
    fi
fi
