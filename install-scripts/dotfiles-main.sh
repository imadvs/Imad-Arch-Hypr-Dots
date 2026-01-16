#!/bin/bash
# 💫 Custom Hyprland Dots Installer 💫 #
# Modified to use LOCAL files instead of cloning from GitHub #

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

# Check if Hyprland-Dots exists locally
printf "${NOTE} Installing ${SKY_BLUE}My Hyprland Dots${RESET} using local files....\n"

if [ -d Hyprland-Dots ]; then
  cd Hyprland-Dots
  chmod +x copy.sh
  ./copy.sh 
else
  echo -e "$ERROR Could not find 'Hyprland-Dots' directory in $(pwd)!"
  echo -e "$ERROR Please ensure you are running this script from the root of the repository."
  exit 1
fi

printf "\n%.0s" {1..2}