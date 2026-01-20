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
        # Check iteratively for process existence to hide ASAP
        for i in {1..20}; do
            if kill -0 $WAYBAR_PID 2>/dev/null; then
                kill -SIGUSR1 $WAYBAR_PID
                break
            fi
            sleep 0.1
        done
        # Ensure it caught it
        sleep 0.5
        kill -SIGUSR1 $WAYBAR_PID
    fi
fi
