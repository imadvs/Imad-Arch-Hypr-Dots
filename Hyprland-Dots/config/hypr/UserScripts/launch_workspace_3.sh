#!/bin/bash

# Configuration
POMO_URL="https://pomofocus.io/app"
MUSIC_URL="https://music.youtube.com"
APP_LAUNCHER="omarchy-launch-webapp"

# Check if windows already exist
if ! hyprctl clients | grep -q "pomofocus"; then
    $APP_LAUNCHER "$POMO_URL" --ozone-platform-hint=auto --disable-gpu &
fi

if ! hyprctl clients | grep -q "music.youtube.com"; then
    $APP_LAUNCHER "$MUSIC_URL" --ozone-platform-hint=auto &
fi

# Wait and Arrange
MAX_ATTEMPTS=30
for i in $(seq 1 $MAX_ATTEMPTS); do
    # Get JSON output of clients
    CLIENTS=$(hyprctl -j clients)
    
    # Extract info for both windows
    # We use 'select' to find the window objects
    POMO_INFO=$(echo "$CLIENTS" | jq -r '.[] | select(.class | test("pomofocus"))')
    MUSIC_INFO=$(echo "$CLIENTS" | jq -r '.[] | select(.class | test("music.youtube.com"))')

    if [ -n "$POMO_INFO" ] && [ -n "$MUSIC_INFO" ]; then
        
        # Give Hyprland a moment to settle
        sleep 1
        
        # Get X coordinates
        POMO_AT=$(echo "$POMO_INFO" | jq -r '.at[0]')
        MUSIC_AT=$(echo "$MUSIC_INFO" | jq -r '.at[0]')
        
        # If Pomofocus X > Music X, it's on the Right. We want it Left.
        if [ "$POMO_AT" -gt "$MUSIC_AT" ]; then
            # Focus Pomofocus
            hyprctl dispatch focuswindow "class:.*pomofocus.*"
            # Swap with the window to the left (Music)
            hyprctl dispatch swapwindow l
            sleep 0.5
        fi
        
        # Final resizing
        hyprctl dispatch focuswindow "class:.*pomofocus.*"
        sleep 0.2
        hyprctl dispatch splitratio -0.3
        
        break
    fi
    sleep 1
done
