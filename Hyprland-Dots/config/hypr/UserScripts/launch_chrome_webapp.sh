#!/bin/bash
# Helper script to launch web apps in Chrome app mode
# Usage: ./launch_chrome_webapp.sh "<URL>"

URL="$1"

if [ -z "$URL" ]; then
    notify-send "Web App Error" "No URL provided"
    exit 1
fi

# Launch Chrome in app mode (no address bar)
# Using uwsm app wrapper as preferred by user config
uwsm app -- google-chrome-stable --password-store=basic --new-window --app="$URL"
