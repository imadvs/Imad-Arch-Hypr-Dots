#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for keyboard backlights (if supported) using brightnessctl

iDIR="$HOME/.config/swaync/icons"

# Get keyboard brightness
get_kbd_backlight() {
	echo $(brightnessctl -d '*::kbd_backlight' -m | cut -d, -f4)
}

# Get icon
get_icon() {
    echo "󰘚"
}

# Notify
notify_user() {
    local icon=$(get_icon)
    notify-send -e -h string:x-canonical-private-synchronous:brightness_notif -h int:value:$current -h boolean:SWAYNC_BYPASS_DND:true -u low "$icon  Keyboard Brightness: $current%"
}

# Change brightness
change_kbd_backlight() {
	brightnessctl -d *::kbd_backlight set "$1" && get_icon && notify_user
}

# Execute accordingly
case "$1" in
	"--get")
		get_kbd_backlight
		;;
	"--inc")
		change_kbd_backlight "+30%"
		;;
	"--dec")
		change_kbd_backlight "30%-"
		;;
	*)
		get_kbd_backlight
		;;
esac
