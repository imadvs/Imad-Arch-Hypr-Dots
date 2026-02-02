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
hyprctl dispatch workspace 1
sleep 1
echo "Launching VS Code..."
uwsm app -- code &
sleep 2

# --- Workspace 2 ---
echo "Visiting Workspace 2..."
hyprctl dispatch workspace 2
sleep 1
echo "Launching Obsidian..."
uwsm app -- obsidian &
sleep 2

echo "Launching ProgrammingAdvices..."
uwsm app -- google-chrome-stable --class="chrome-programmingadvices" --password-store=basic --new-window --app="https://programmingadvices.com/l/dashboard" &
sleep 4 # Wait for P.Advices to spawn

# Resize Workspace 2
echo "Resizing Workspace 2..."
hyprctl dispatch focuswindow "title:^(.*ProgrammingAdvices.*|.*Dashboard.*|.*programmingadvices.*)$"
hyprctl dispatch splitratio 0.15
echo "Waiting for WS2 icons to settle..."
sleep 5 # Extensive wait to ensure Waybar registers icons before switching

# --- Workspace 3 ---
echo "Visiting Workspace 3..."
hyprctl dispatch workspace 3
sleep 1
echo "Launching Busuu..."
uwsm app -- google-chrome-stable --class="chrome-busuu" --password-store=basic --new-window --app="https://www.busuu.com" &
sleep 1
echo "Launching Managementdose..."
uwsm app -- google-chrome-stable --class="chrome-managementdose" --password-store=basic --new-window --app="https://managementdose.com" &
sleep 3

# Resize Workspace 3
# With Chrome, titles might differ. Using broad matching.
# Swapping focus to Busuu first (Main Left), then ManagementDose (Right Split)
echo "Resizing Workspace 3..."
hyprctl dispatch focuswindow "class:^(chrome-managementdose.*)$"
hyprctl dispatch splitratio 0.15

# --- Workspace 4 ---
echo "Visiting Workspace 4..."
hyprctl dispatch workspace 4
sleep 1
echo "Launching YouTube Music..."
uwsm app -- google-chrome-stable --class="chrome-youtubemusic" --password-store=basic --new-window --app="https://music.youtube.com" &
sleep 2

echo "Launching Pomofocus..."
uwsm app -- kitty --class "pomofocus" --title "Pomofocus" python3 /home/imad/.config/hypr/UserScripts/pomo.py &
sleep 4 # Wait for Pomo to spawn

# Resize Workspace 4
echo "Resizing Workspace 4..."
hyprctl dispatch focuswindow "class:^(pomofocus)$"
# hyprctl dispatch movewindow l
# hyprctl dispatch splitratio -0.5

# --- Final Cleanup ---
sleep 1
echo "Returning to Workspace 1..."
hyprctl dispatch workspace 1
sleep 1
# Reduced sleep for reload
hyprctl reload

echo "--- Startup Script Finished ---"
