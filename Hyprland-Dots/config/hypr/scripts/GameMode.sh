#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Game Mode. Turning off all animations

notif="$HOME/.config/swaync/images/ja.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"

HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = "true" ] ; then
    hyprctl eval 'hl.config({ animations = { enabled = false }, decoration = { shadow = { enabled = false }, blur = { enabled = false }, rounding = 0 }, general = { gaps_in = 0, gaps_out = 0, border_size = 1 } })'
    hyprctl eval 'hl.window_rule({ match = { class = "^(.*)$" }, opacity = "1 1 override" })'
    awww kill 
    notify-send -e -h string:x-canonical-private-synchronous:gamemode_notif -u low "󰓓  Gamemode:" "Enabled"
    sleep 0.1
    exit
else
    awww-daemon --format xrgb && awww img "$HOME/.config/rofi/.current_wallpaper" &
    sleep 0.1
    ${SCRIPTSDIR}/WallustSwww.sh
    sleep 0.5
    hyprctl reload
    ${SCRIPTSDIR}/Refresh.sh	 
    notify-send -e -h string:x-canonical-private-synchronous:gamemode_notif -u normal "󰓓  Gamemode:" "Disabled"
    exit
fi
hyprctl reload
