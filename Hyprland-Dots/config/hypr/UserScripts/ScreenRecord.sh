#!/bin/bash

# Screen recording script
# Allows selecting between fullscreen and a selected region.

# Check if recorder is running and stop it
if pgrep -x "wl-screenrec" > /dev/null; then
    pkill -INT -x wl-screenrec
    notify-send "Screen Recording" "Recording stopped and saved to ~/Videos/Recordings" -i video-x-generic
    exit 0
fi
if pgrep -x "wf-recorder" > /dev/null; then
    pkill -INT -x wf-recorder
    notify-send "Screen Recording" "Recording stopped and saved to ~/Videos/Recordings" -i video-x-generic
    exit 0
fi

# Options
SELECTION=$(echo -e "  Fullscreen\n  Selected Region\n󰜺  Cancel" | rofi -dmenu -i -p "Screen Record:" -theme-str 'listview { lines: 3; } window { width: 400px; }')

# Ensure Videos/Recordings exists
VID_DIR="$HOME/Videos/Recordings"
mkdir -p "$VID_DIR"
FILENAME="$VID_DIR/Rec_$(date +'%Y-%m-%d_%H-%M-%S').mp4"

if [[ "$SELECTION" == *"Fullscreen"* ]]; then
    notify-send "Screen Recording" "Starting FULLSCREEN recording..." -i video-x-generic
    if command -v wl-screenrec &> /dev/null; then
        wl-screenrec -f "$FILENAME"
    elif command -v wf-recorder &> /dev/null; then
        wf-recorder -f "$FILENAME"
    else
        notify-send "Screen Recording Error" "No recorder installed (wl-screenrec/wf-recorder)" -i dialog-error
    fi
elif [[ "$SELECTION" == *"Selected Region"* ]]; then
    REGION=$(slurp)
    if [ -z "$REGION" ]; then
        exit 0
    fi
    notify-send "Screen Recording" "Starting REGION recording..." -i video-x-generic
    if command -v wl-screenrec &> /dev/null; then
        wl-screenrec -g "$REGION" -f "$FILENAME"
    elif command -v wf-recorder &> /dev/null; then
        wf-recorder -g "$REGION" -f "$FILENAME"
    else
        notify-send "Screen Recording Error" "No recorder installed (wl-screenrec/wf-recorder)" -i dialog-error
    fi
fi
