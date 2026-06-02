#!/usr/bin/env bash
# Wait 15 seconds
sleep 15
pgrep -x hyprlock > /dev/null || exit 0
hyprctl dispatch 'hl.dsp.dpms({ action = "off" })'

# Wait 165 seconds (total 180s = 3 minutes)
sleep 165
pgrep -x hyprlock > /dev/null || exit 0
systemctl suspend
