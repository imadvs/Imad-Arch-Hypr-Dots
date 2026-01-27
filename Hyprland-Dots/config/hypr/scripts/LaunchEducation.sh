#!/bin/bash

# Function to launch if not running
safe_launch() {
    process_pattern=$1
    launch_command=$2
    
    # Check for running brave instance with the specific app URL
    # grep -v grep avoids matching the grep process itself
    # grep -v LaunchEducation avoids matching this script
    if ps aux | grep "brave" | grep "$process_pattern" | grep -v "grep" | grep -v "LaunchEducation" > /dev/null; then
        echo "$process_pattern is already running."
    else
        echo "Launching $process_pattern..."
        $launch_command --password-store=basic &
    fi
}

# Launch Busuu
safe_launch "busuu.com" "gtk-launch busuu"

# Wait for window to register
sleep 2

# Launch Management Dose
safe_launch "managementdose.com" "gtk-launch managementdose"
