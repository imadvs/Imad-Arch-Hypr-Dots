#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Airplane Mode. Turning on or off all wifi using rfkill. 

notif="$HOME/.config/swaync/images/ja.png"

# Check if any wireless device is blocked
wifi_blocked=$(rfkill list wifi | grep -o "Soft blocked: yes")

if [ -n "$wifi_blocked" ]; then
    rfkill unblock wifi
    notify-send -e -h string:x-canonical-private-synchronous:airplane_notif -u low "󰀝  Airplane Mode:" "Switched OFF"
else
    rfkill block wifi
    notify-send -e -h string:x-canonical-private-synchronous:airplane_notif -u low "󰀝  Airplane Mode:" "Switched ON"
fi
