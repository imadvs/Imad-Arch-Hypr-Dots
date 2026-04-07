#!/bin/bash

# Screen recording script
# Allows selecting between fullscreen and a selected region.

# Check if recorder is running and stop it
if pgrep -x "gpu-screen-reco" > /dev/null; then
    pkill -INT -x gpu-screen-reco
    notify-send "Screen Recording" "Recording stopped and saved to ~/Videos/Recordings" -i video-x-generic
    exit 0
fi
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
    # Silent start to avoid notification in video
    ACTIVE_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name' | head -n 1)
    if [ -z "$ACTIVE_MONITOR" ] || [ "$ACTIVE_MONITOR" == "null" ]; then
        ACTIVE_MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
    fi
    if command -v gpu-screen-recorder &> /dev/null; then
        gpu-screen-recorder -w "$ACTIVE_MONITOR" -f 60 -a default_output -o "$FILENAME" > /tmp/screenrecord.log 2>&1 &
    elif command -v wl-screenrec &> /dev/null; then
        wl-screenrec -o "$ACTIVE_MONITOR" -f "$FILENAME" > /tmp/screenrecord.log 2>&1 &
    elif command -v wf-recorder &> /dev/null; then
        wf-recorder -o "$ACTIVE_MONITOR" -f "$FILENAME" > /tmp/screenrecord.log 2>&1 &
    else
        notify-send "Screen Recording Error" "No recorder installed" -i dialog-error
    fi
elif [[ "$SELECTION" == *"Selected Region"* ]]; then
    REGION=$(slurp)
    if [ -z "$REGION" ]; then
        exit 0
    fi
    # Silent start to avoid notification in video
    if command -v gpu-screen-recorder &> /dev/null; then
        GSR_REGION=$(echo "$REGION" | awk -F'[, ]' '{print $3"+"$1"+"$2}')
        gpu-screen-recorder -w region -region "$GSR_REGION" -f 60 -a default_output -o "$FILENAME" > /tmp/screenrecord.log 2>&1 &
    elif command -v wl-screenrec &> /dev/null; then
        wl-screenrec -g "$REGION" -f "$FILENAME" > /tmp/screenrecord.log 2>&1 &
    elif command -v wf-recorder &> /dev/null; then
        wf-recorder -g "$REGION" -f "$FILENAME" > /tmp/screenrecord.log 2>&1 &
    else
        notify-send "Screen Recording Error" "No recorder installed" -i dialog-error
    fi
fi
