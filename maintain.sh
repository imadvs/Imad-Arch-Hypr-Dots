#!/bin/bash
# 💫 My-Hyprland Maintenance Script 💫
# Usage: ./maintain.sh "Commit Message"

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="$HOME/.config"
COMMIT_MSG="$1"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting Dotfiles Sync...${NC}"

# ==============================================================================
# 1. Sync Configurations (User Configs -> Repo)
# ==============================================================================
Jakoolit_DIR="$HOME/Arch-Hyprland/Hyprland-Dots/config"
TARGET_DIR="$REPO_DIR/Hyprland-Dots/config"

if [ -d "$Jakoolit_DIR" ]; then
    echo -e "${YELLOW}Syncing Configurations...${NC}"
    for item in "$Jakoolit_DIR"/*; do
        base_name=$(basename "$item")
        if [ -d "$CONFIG_DIR/$base_name" ] || [ -f "$CONFIG_DIR/$base_name" ]; then
            # Sync, deleting extraneous files in destination to keep it 1:1
            rsync -aq --delete "$CONFIG_DIR/$base_name" "$TARGET_DIR/"
            echo -e "  Synced: $base_name"
        fi
    done
else
    echo -e "${RED}Warning: Reference directory $Jakoolit_DIR not found. Skipping config sync based on reference.${NC}"
fi

# ==============================================================================
# 2. Sync Wallpapers (Pictures -> Repo)
# ==============================================================================
WALLPAPER_SRC="$HOME/Pictures/wallpapers"
WALLPAPER_DEST="$REPO_DIR/Hyprland-Dots/wallpapers"

if [ -d "$WALLPAPER_SRC" ]; then
    echo -e "${YELLOW}Syncing Wallpapers...${NC}"
    mkdir -p "$WALLPAPER_DEST"
    rsync -aq --delete "$WALLPAPER_SRC/" "$WALLPAPER_DEST/"
    echo -e "  Wallpapers synced."
fi

# ==============================================================================
# 3. Sync Custom Desktop Files (Local -> Repo)
# ==============================================================================
DESKTOP_SRC="$HOME/.local/share/applications"
DESKTOP_DEST="$REPO_DIR/assets/applications"

if ls "$DESKTOP_SRC"/*.desktop 1> /dev/null 2>&1; then
    echo -e "${YELLOW}Syncing Custom Desktop Files...${NC}"
    mkdir -p "$DESKTOP_DEST"
    rsync -aq "$DESKTOP_SRC/"*.desktop "$DESKTOP_DEST/"
    echo -e "  Desktop files synced."
fi

# ==============================================================================
# 4. Sync Shell Configs (.zshrc)
# ==============================================================================
echo -e "${YELLOW}Syncing Shell Configs...${NC}"
cp "$HOME/.zshrc" "$REPO_DIR/assets/.zshrc"
echo -e "  .zshrc synced."

# ==============================================================================
# 5. Git Operations
# ==============================================================================
echo -e "${BLUE}Git Operations...${NC}"
cd "$REPO_DIR" || exit

# Add all changes
git add .

# Status check
if git diff-index --quiet HEAD --; then
    echo -e "${GREEN}No changes to commit.${NC}"
else
    # Commit
    if [ -z "$COMMIT_MSG" ]; then
        COMMIT_MSG="Update dotfiles: $(date +'%Y-%m-%d %H:%M')"
    fi
    git commit -m "$COMMIT_MSG"
    echo -e "${GREEN}Committed with message: '${COMMIT_MSG}'${NC}"

    # Push
    echo -e "${YELLOW}Pushing to remote...${NC}"
    if git push; then
        echo -e "${GREEN}Successfully pushed to GitHub!${NC}"
    else
        echo -e "${RED}Push failed. (Did you set up your git remote?)${NC}"
    fi
fi

echo -e "${BLUE}Done!${NC}"
