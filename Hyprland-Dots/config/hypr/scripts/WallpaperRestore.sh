#!/usr/bin/env bash
set -euo pipefail

cache_file="$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"
wallDIR="$HOME/Pictures/wallpapers"
scriptsDir="$HOME/.config/hypr/scripts"

if ! pgrep -x "awww-daemon" > /dev/null; then
  awww-daemon --format argb &
  sleep 1
fi

if [[ -f "$cache_file" ]]; then
  wallpaper_path="$cache_file"
else
  picks=($(find -L "$wallDIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.pnm" -o -name "*.tga" -o -name "*.tiff" -o -name "*.webp" -o -name "*.bmp" -o -name "*.farbfeld" -o -name "*.gif" \) 2>/dev/null))
  if [[ ${#picks[@]} -eq 0 ]]; then
    exit 0
  fi
  wallpaper_path="${picks[$((RANDOM % ${#picks[@]}))]}"
fi

awww img "$wallpaper_path" --transition-fps 30 --transition-type grow --transition-duration 2
"$scriptsDir/WallustSwww.sh" "$wallpaper_path"
