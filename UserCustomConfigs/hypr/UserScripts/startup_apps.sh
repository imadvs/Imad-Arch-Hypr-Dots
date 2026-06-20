#!/bin/bash
# Startup script - launches apps and moves them to correct workspaces
LOGfile="$HOME/startup_debug.log"
exec > >(tee -a "$LOGfile") 2>&1

echo "--- Starting Startup Script at $(date) ---"

# Wait for Hyprland to fully initialize
sleep 3

# --- Sequential Startup (Workspace 1 -> 4) ---
echo "Starting Sequential Launch..."

# --- Workspace 1 ---
echo "Visiting Workspace 1..."
hyprctl dispatch 'hl.dsp.focus({ workspace = 1 })'
sleep 1
echo "Launching CLion..."
uwsm app -- /usr/bin/clion &
sleep 8

# --- Workspace 2 ---
echo "Visiting Workspace 2..."
hyprctl dispatch 'hl.dsp.focus({ workspace = 2 })'
sleep 1
echo "Launching Obsidian..."
uwsm app -- obsidian &
sleep 2

echo "Launching ProgrammingAdvices..."
uwsm app -- env NVD_BACKEND=direct LIBVA_DRIVER_NAME=nvidia google-chrome-stable --ozone-platform-hint=auto --enable-features=VaapiVideoDecoder,VaapiVideoEncoder,VaapiIgnoreDriverChecks --class="chrome-programmingadvices" --password-store=basic --new-window --app="https://programmingadvices.com/l/dashboard" &
sleep 7 # Wait for P.Advices to spawn

# Resize Workspace 2
echo "Resizing Workspace 2..."
hyprctl dispatch 'hl.dsp.focus({ window = "title:^(.*ProgrammingAdvices.*|.*Dashboard.*|.*programmingadvices.*)$" })'
hyprctl dispatch 'hl.dsp.layout("splitratio 0.15")'
echo "Waiting for WS2 icons to settle..."
sleep 8 # Extensive wait to ensure Waybar registers icons before switching

# --- Workspace 3 ---
echo "Visiting Workspace 3..."
hyprctl dispatch 'hl.dsp.focus({ workspace = 3 })'
sleep 1
echo "Launching Busuu..."
uwsm app -- env NVD_BACKEND=direct LIBVA_DRIVER_NAME=nvidia google-chrome-stable --ozone-platform-hint=auto --enable-features=VaapiVideoDecoder,VaapiVideoEncoder,VaapiIgnoreDriverChecks --class="chrome-busuu" --password-store=basic --new-window --app="https://www.busuu.com" &
sleep 1
echo "Launching Managementdose..."
uwsm app -- env NVD_BACKEND=direct LIBVA_DRIVER_NAME=nvidia google-chrome-stable --ozone-platform-hint=auto --enable-features=VaapiVideoDecoder,VaapiVideoEncoder,VaapiIgnoreDriverChecks --class="chrome-managementdose" --password-store=basic --new-window --app="https://managementdose.com" &
sleep 3

# Resize Workspace 3
# With Chrome, titles might differ. Using broad matching.
# Swapping focus to Busuu first (Main Left), then ManagementDose (Right Split)
echo "Resizing Workspace 3..."
hyprctl dispatch 'hl.dsp.focus({ window = "class:^(chrome-managementdose.*)$" })'
hyprctl dispatch 'hl.dsp.layout("splitratio 0.15")'

# --- Workspace 4 ---
echo "Visiting Workspace 4..."
hyprctl dispatch 'hl.dsp.focus({ workspace = 4 })'
sleep 1

echo "Launching Pomofocus..."
uwsm app -- kitty --class "pomofocus" --title "Pomofocus" python3 /home/imad/.config/hypr/UserScripts/pomo.py &
sleep 2

# --- Final Cleanup ---
sleep 1
echo "Returning to Workspace 1..."
hyprctl dispatch 'hl.dsp.focus({ workspace = 1 })'
sleep 1
# Reduced sleep for reload
hyprctl reload

echo "--- Startup Script Finished ---"
