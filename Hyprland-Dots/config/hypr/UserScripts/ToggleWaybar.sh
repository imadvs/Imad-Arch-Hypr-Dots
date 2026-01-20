#!/bin/bash
# Toggle Waybar and save state

STATE_FILE="$HOME/.config/hypr/waybar_state"

# Ensure file exists, default to visible
if [ ! -f "$STATE_FILE" ]; then
    echo "visible" > "$STATE_FILE"
fi

CURRENT_STATE=$(cat "$STATE_FILE")

if [ "$CURRENT_STATE" == "visible" ]; then
    # Was visible, now hiding
    pkill -SIGUSR1 waybar
    echo "hidden" > "$STATE_FILE"
else
    # Was hidden, now showing
    pkill -SIGUSR1 waybar
    echo "visible" > "$STATE_FILE"
fi
