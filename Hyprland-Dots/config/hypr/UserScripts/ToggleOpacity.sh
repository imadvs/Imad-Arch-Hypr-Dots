#!/usr/bin/env bash
# Toggle all windows between normal opacity and fully opaque

STATE_FILE="/tmp/hypr_opacity_toggle"

if [ -f "$STATE_FILE" ]; then
    rm "$STATE_FILE"
    hyprctl reload
    notify-send -e -h string:x-canonical-private-synchronous:opacity_notif -u low "Opacity:" "Normal (restored)"
else
    touch "$STATE_FILE"
    hyprctl eval 'hl.config({ decoration = { active_opacity = 1.0, inactive_opacity = 1.0 } })'
    hyprctl eval 'hl.window_rule({ match = { class = "^(.*)$" }, opacity = "1 1 override" })'
    notify-send -e -h string:x-canonical-private-synchronous:opacity_notif -u low "Opacity:" "Fully Opaque"
fi
