#!/bin/bash
# 💫 Custom GTK Themes Installer 💫 #
# Modified to skip external cloning/installation if assets are missing #

engine=(
    unzip
    gtk-engine-murrine
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || { echo "${ERROR} Failed to change directory to $PARENT_DIR"; exit 1; }

# Source the global functions script
if ! source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"; then
  echo "Failed to source Global_functions.sh"
  exit 1
fi

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_themes.log"

# installing engine needed for gtk themes
for PKG1 in "${engine[@]}"; do
    install_package "$PKG1" "$LOG"
done

# Check if the directory exists locally (bundled)
if [ -d "GTK-themes-icons" ]; then
    echo "$NOTE Local GTK themes and Icons directory found..." 2>&1 | tee -a "$LOG"
    cd GTK-themes-icons
    if [ -f "auto-extract.sh" ]; then
        chmod +x auto-extract.sh
        ./auto-extract.sh
        cd ..
        echo "$OK Extracted GTK Themes & Icons to ~/.icons & ~/.themes directories" 2>&1 | tee -a "$LOG"
    else
         echo "$ERROR auto-extract.sh not found in GTK-themes-icons" 2>&1 | tee -a "$LOG"
    fi
else
    echo "$NOTE No local 'GTK-themes-icons' found. Skipping theme installation." 2>&1 | tee -a "$LOG"
    echo "$NOTE If you want to install themes, please clone them manually or bundle them in the repo." 2>&1 | tee -a "$LOG"
fi

printf "\n%.0s" {1..2}