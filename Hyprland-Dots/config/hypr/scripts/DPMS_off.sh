#!/usr/bin/env bash
echo "$(date): DPMS_off.sh called. pgrep hyprlock is: $(pgrep -x hyprlock)" >> /tmp/dpms_test.log
if pgrep -x hyprlock > /dev/null; then
    hyprctl dispatch dpms off
    echo "$(date): DPMS off executed" >> /tmp/dpms_test.log
else
    echo "$(date): hyprlock not found, ignoring" >> /tmp/dpms_test.log
fi
