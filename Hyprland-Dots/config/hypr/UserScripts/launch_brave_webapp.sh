#!/bin/bash
# Helper script to launch web apps in Brave (Chromium) app mode
# Usage: ./launch_brave_webapp.sh "<URL>"

URL="$1"

if [ -z "$URL" ]; then
    notify-send "Web App Error" "No URL provided"
    exit 1
fi

# Launch Brave in app mode (no address bar)
# Using uwsm app wrapper as preferred by user config
uwsm app -- brave --password-store=basic --new-window --app="$URL"
