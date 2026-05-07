#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# for changing Hyprland Layouts (Master or Dwindle) on the fly

notif="$HOME/.config/swaync/images/ja.png"

LAYOUT=$(hyprctl -j getoption general:layout | jq '.str' | sed 's/"//g')

case $LAYOUT in
"master")
	hyprctl keyword general:layout dwindle
	# SUPER+J/K are global and managed by KeybindsLayoutInit.sh; only manage SUPER+O here
	hyprctl keyword bind SUPER,O,togglesplit
  notify-send -e -h string:x-canonical-private-synchronous:layout_notif -u low "󰕰  Layout:" "Dwindle"
	;;
"dwindle")
	hyprctl keyword general:layout master
	# Drop togglesplit binding on SUPER+O when switching back to master
	hyprctl keyword unbind SUPER,O
  notify-send -e -h string:x-canonical-private-synchronous:layout_notif -u low "󰕰  Layout:" "Master"
	;;
*) ;;

esac
