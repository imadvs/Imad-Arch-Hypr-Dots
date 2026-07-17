#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# for changing Hyprland Layouts (Master or Dwindle) on the fly

notif="$HOME/.config/swaync/images/ja.png"

LAYOUT=$(hyprctl -j getoption general:layout | jq '.str' | sed 's/"//g')

case $LAYOUT in
"master")
	hyprctl eval 'hl.config({ general = { layout = "dwindle" } })'
	hyprctl eval 'hl.bind("SUPER + O", hl.dsp.layout("togglesplit"))'
  notify-send -e -h string:x-canonical-private-synchronous:layout_notif -u low "󰕰  Layout:" "Dwindle"
	;;
"dwindle")
	hyprctl eval 'hl.config({ general = { layout = "master" } })'
	hyprctl eval 'hl.bind("SUPER + O", hl.dsp.exec_cmd("true"))'
  notify-send -e -h string:x-canonical-private-synchronous:layout_notif -u low "󰕰  Layout:" "Master"
	;;
*) ;;

esac
