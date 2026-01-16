#!/bin/bash
# Startup script - launches apps and moves them to correct workspaces
LOGfile="$HOME/startup_debug.log"
exec > >(tee -a "$LOGfile") 2>&1

echo "--- Starting Startup Script at $(date) ---"

# Wait for Hyprland to fully initialize
sleep 3

# --- Workspace 1: VS Code ---
echo "Launching VS Code..."
uwsm app -- code &
sleep 3
echo "Moving VS Code..."
hyprctl dispatch movetoworkspacesilent "1,class:^(Code|code)$"

# --- Workspace 2: Obsidian ---
echo "Launching Obsidian..."
uwsm app -- obsidian &
sleep 3
echo "Moving Obsidian..."
hyprctl dispatch movetoworkspacesilent "2,class:^(obsidian)$"

# --- Workspace 2: ProgrammingAdvices ---
echo "Launching ProgrammingAdvices..."
uwsm app -- brave --password-store=basic --new-window --app="https://programmingadvices.com/l/dashboard" &
sleep 5
echo "Clients before move (ProgrammingAdvices):" >>"$LOGfile"
hyprctl clients | grep "title:" >>"$LOGfile"
echo "Moving ProgrammingAdvices..."
hyprctl dispatch movetoworkspacesilent "2,title:^(.*ProgrammingAdvices.*|.*Dashboard.*|.*programmingadvices.*)$"

# Resize Workspace 2 (Make Programming Advices small like Pomofocus)
sleep 1
hyprctl dispatch workspace 2
hyprctl dispatch focuswindow "title:^(.*ProgrammingAdvices.*|.*Dashboard.*|.*programmingadvices.*)$"
hyprctl dispatch splitratio 0.5

# --- Workspace 3: YouTube Music ---
echo "Launching YouTube Music..."
uwsm app -- brave --password-store=basic --new-window --app="https://music.youtube.com" &
sleep 5
echo "Clients before move (YouTube Music):" >>"$LOGfile"
hyprctl clients | grep "title:" >>"$LOGfile"
echo "Moving YouTube Music..."
hyprctl dispatch movetoworkspacesilent "3,title:^(.*YouTube Music.*|.*music.youtube.com.*)$"

# --- Workspace 3: Pomofocus ---
echo "Launching Pomofocus..."
uwsm app -- brave --password-store=basic --new-window --app="https://pomofocus.io/app" &
sleep 5
echo "Clients before move (Pomofocus):" >>"$LOGfile"
hyprctl clients | grep "title:" >>"$LOGfile"
echo "Moving Pomofocus..."
# Broader regex to catch "Pomodoro Timer", "Time to focus", etc.
hyprctl dispatch movetoworkspacesilent "3,title:^(.*Pomofocus.*|.*Time to focus.*|.*Pomodoro.*)$"

# Resize Workspace 3 (Make Pomofocus smaller)
sleep 1
hyprctl dispatch workspace 3
hyprctl dispatch focuswindow "title:^(.*Pomofocus.*|.*Time to focus.*|.*Pomodoro.*)$"
hyprctl dispatch movewindow l
hyprctl dispatch splitratio -0.5

# Return to workspace 1
sleep 1
hyprctl dispatch workspace 1

echo "--- Startup Script Finished ---"

# Force a reload to ensure all keybinds and configs are applied correctly
sleep 2
hyprctl reload
