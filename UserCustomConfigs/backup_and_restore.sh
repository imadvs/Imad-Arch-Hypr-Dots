#!/usr/bin/env bash
# =========================================================================
#  User Custom Configurations Backup & Restore Utility
#  Author: Antigravity AI
#  Description: Easily backup and restore your personal customizations
#               (like Glass Wlogout, custom Wallust templates, Pomodoro timer, etc.)
#               after updating your main dotfiles.
# =========================================================================

CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$CONFIG_DIR/UserCustomConfigs"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

show_usage() {
    echo -e "Usage: $0 {backup|restore}"
    echo -e "  ${BLUE}backup${NC}  - Copy all your active customizations into the UserCustomConfigs folder"
    echo -e "  ${BLUE}restore${NC} - Apply your saved customizations back to active system config folders"
}

do_backup() {
    echo -e "${YELLOW}Starting backup of your custom configurations...${NC}"
    
    # Create directories
    mkdir -p "$BACKUP_DIR/wlogout"
    mkdir -p "$BACKUP_DIR/btop"
    mkdir -p "$BACKUP_DIR/fastfetch"
    mkdir -p "$BACKUP_DIR/wallust/templates"
    mkdir -p "$BACKUP_DIR/hypr/UserScripts"
    mkdir -p "$BACKUP_DIR/hypr/UserConfigs"

    # 1. Backup Wlogout (Glass Theme, icons, and layout)
    if [ -d "$CONFIG_DIR/wlogout" ]; then
        cp -rf "$CONFIG_DIR/wlogout/"* "$BACKUP_DIR/wlogout/"
        echo -e "  [✓] Wlogout (Glass Theme & Layout)"
    fi

    # 2. Backup Btop Config (preserving Wallust theme link & transparent bg)
    if [ -f "$CONFIG_DIR/btop/btop.conf" ]; then
        cp -f "$CONFIG_DIR/btop/btop.conf" "$BACKUP_DIR/btop/"
        echo -e "  [✓] Btop Config"
    fi

    # 3. Backup Fastfetch Config & Assets (preserving arch.png and settings)
    if [ -f "$CONFIG_DIR/fastfetch/config.jsonc" ]; then
        cp -f "$CONFIG_DIR/fastfetch/config.jsonc" "$BACKUP_DIR/fastfetch/"
    fi
    if [ -f "$CONFIG_DIR/fastfetch/arch.png" ]; then
        cp -f "$CONFIG_DIR/fastfetch/arch.png" "$BACKUP_DIR/fastfetch/"
    fi
    echo -e "  [✓] Fastfetch (config & logos)"

    # 4. Backup Wallust Configuration & Custom Templates
    if [ -f "$CONFIG_DIR/wallust/wallust.toml" ]; then
        cp -f "$CONFIG_DIR/wallust/wallust.toml" "$BACKUP_DIR/wallust/"
    fi
    
    # Only copy templates that you actively customize/add
    custom_templates=(
        "colors-btop.theme"
        "colors-clock-rs.toml"
        "colors-rmpc.ron"
        "chrome-manifest.json"
        "colors-wal.vim"
        "sequences"
        "yt-x-theme"
        "colors-hyprland.lua"
    )
    for t in "${custom_templates[@]}"; do
        if [ -f "$CONFIG_DIR/wallust/templates/$t" ]; then
            cp -f "$CONFIG_DIR/wallust/templates/$t" "$BACKUP_DIR/wallust/templates/"
        fi
    done
    echo -e "  [✓] Wallust Config & Custom Templates"

    # 5. Backup Hyprland Startup Apps (Pomodoro setup)
    if [ -f "$CONFIG_DIR/hypr/UserScripts/startup_apps.sh" ]; then
        cp -f "$CONFIG_DIR/hypr/UserScripts/startup_apps.sh" "$BACKUP_DIR/hypr/UserScripts/"
        echo -e "  [✓] Hyprland Startup Apps (Pomodoro)"
    fi

    # 6. Backup Hyprland System Configurations (hyprland.lua & UserConfigs directory)
    if [ -f "$CONFIG_DIR/hypr/hyprland.lua" ]; then
        cp -f "$CONFIG_DIR/hypr/hyprland.lua" "$BACKUP_DIR/hypr/"
        echo -e "  [✓] Main hyprland.lua Config"
    fi
    if [ -d "$CONFIG_DIR/hypr/UserConfigs" ]; then
        cp -rf "$CONFIG_DIR/hypr/UserConfigs/"* "$BACKUP_DIR/hypr/UserConfigs/"
        echo -e "  [✓] UserConfigs folder"
    fi

    echo -e "${GREEN}Backup complete! All your custom configurations are organized in: $BACKUP_DIR${NC}"
}

do_restore() {
    echo -e "${YELLOW}Restoring your custom configurations...${NC}"

    if [ ! -d "$BACKUP_DIR" ]; then
        echo -e "${RED}Error: Backup directory $BACKUP_DIR does not exist. Please run backup first.${NC}"
        exit 1
    fi

    # 1. Restore Wlogout
    if [ -d "$BACKUP_DIR/wlogout" ]; then
        rm -rf "$CONFIG_DIR/wlogout"
        cp -rf "$BACKUP_DIR/wlogout" "$CONFIG_DIR/"
        echo -e "  [✓] Restored Wlogout"
    fi

    # 2. Restore Btop Config
    if [ -f "$BACKUP_DIR/btop/btop.conf" ]; then
        mkdir -p "$CONFIG_DIR/btop"
        cp -f "$BACKUP_DIR/btop/btop.conf" "$CONFIG_DIR/btop/"
        echo -e "  [✓] Restored Btop Config"
    fi

    # 3. Restore Fastfetch
    if [ -d "$BACKUP_DIR/fastfetch" ]; then
        mkdir -p "$CONFIG_DIR/fastfetch"
        cp -rf "$BACKUP_DIR/fastfetch/"* "$CONFIG_DIR/fastfetch/"
        echo -e "  [✓] Restored Fastfetch"
    fi

    # 4. Restore Wallust Configuration & Custom Templates
    if [ -f "$BACKUP_DIR/wallust/wallust.toml" ]; then
        mkdir -p "$CONFIG_DIR/wallust/templates"
        cp -f "$BACKUP_DIR/wallust/wallust.toml" "$CONFIG_DIR/wallust/"
        cp -rf "$BACKUP_DIR/wallust/templates/"* "$CONFIG_DIR/wallust/templates/"
        echo -e "  [✓] Restored Wallust Config & Custom Templates"
    fi

    # 5. Restore Hyprland Startup Apps (Pomodoro setup)
    if [ -f "$BACKUP_DIR/hypr/UserScripts/startup_apps.sh" ]; then
        mkdir -p "$CONFIG_DIR/hypr/UserScripts"
        cp -f "$BACKUP_DIR/hypr/UserScripts/startup_apps.sh" "$CONFIG_DIR/hypr/UserScripts/"
        echo -e "  [✓] Restored Hyprland Startup Apps (Pomodoro)"
    fi

    # 6. Restore Hyprland System Configurations (hyprland.lua & UserConfigs directory)
    if [ -f "$BACKUP_DIR/hypr/hyprland.lua" ]; then
        cp -f "$BACKUP_DIR/hypr/hyprland.lua" "$CONFIG_DIR/hypr/"
        echo -e "  [✓] Restored Main hyprland.lua Config"
    fi
    if [ -d "$BACKUP_DIR/hypr/UserConfigs" ]; then
        mkdir -p "$CONFIG_DIR/hypr/UserConfigs"
        cp -rf "$BACKUP_DIR/hypr/UserConfigs/"* "$CONFIG_DIR/hypr/UserConfigs/"
        echo -e "  [✓] Restored UserConfigs folder"
    fi

    echo -e "${YELLOW}Refreshing system components with your configurations...${NC}"
    
    # Reload Wallust to apply colors
    if command -v wallust &>/dev/null; then
        # Find active wallpaper to trigger wallust run
        active_wallpaper=$(cat "$HOME/.cache/current_wallpaper" 2>/dev/null)
        if [ -n "$active_wallpaper" ] && [ -f "$active_wallpaper" ]; then
            wallust run "$active_wallpaper" &>/dev/null
            echo -e "  [✓] Wallust re-run on active wallpaper"
        fi
    fi

    # Refresh Hyprland and Waybar
    hyprctl reload &>/dev/null
    pkill waybar && (uwsm app -- waybar &) &>/dev/null
    echo -e "  [✓] Reloaded Hyprland and Waybar"

    echo -e "${GREEN}Restore complete! All your configurations have been applied successfully.${NC}"
}

case "$1" in
    backup)
        do_backup
        ;;
    restore)
        do_restore
        ;;
    *)
        show_usage
        exit 1
        ;;
esac
