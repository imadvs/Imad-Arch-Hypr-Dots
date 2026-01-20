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
        # Wait for waybar to be ready to receive signal, but check frequently
        # Try to hide it ASAP to minimize flash
        for i in {1..20}; do
            if kill -0 $WAYBAR_PID 2>/dev/null; then
                # Sending SIGUSR1 multiple times is harmless, better than missing it
                kill -SIGUSR1 $WAYBAR_PID
                # If we successfully signaled, maybe we are done? 
                # But waybar might ignore if not fully initialized.
                # Let's keep trying for a split second to be sure or just once?
                # Usually once is enough if process exists.
                break
            fi
            sleep 0.1
        done
        # Send one more time just in case initialization leg
        sleep 0.5
        kill -SIGUSR1 $WAYBAR_PID
    fi
fi
