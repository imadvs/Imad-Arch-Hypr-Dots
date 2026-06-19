#!/bin/bash
# Quickshell Lockscreen Installer - The Last of Us theme

LOG="Install-Logs/install-$(date +%d-%H%M%S)_quickshell-lock.log"
TARGET_DIR="$HOME/.local/share/quickshell-lockscreen"
THEME_NAME="last-of-us"

echo "Installing Quickshell Lockscreen..."

# 1. Deploy wrapper
echo "Copying wrapper to $TARGET_DIR..."
rm -rf "$TARGET_DIR"
cp -r "$(dirname "$(readlink -f "$0")")/../quickshell-lockscreen" "$TARGET_DIR"
chmod +x "$TARGET_DIR/lock.sh"

# 2. Link themes
echo "Linking themes..."
ln -sfn "$(dirname "$(readlink -f "$0")")/../assets" "$TARGET_DIR/themes_link"

# 3. Set default theme
echo "Setting default theme to $THEME_NAME..."
mkdir -p "$HOME/.config/qylock"
echo "$THEME_NAME" > "$HOME/.config/qylock/theme"
sed -i "s/export QS_THEME=.*$/export QS_THEME=\"\${1:-\$(cat \$HOME\/.config\/qylock\/theme 2>\/dev\/null || echo $THEME_NAME)}\"/" "$TARGET_DIR/lock.sh"

echo "Quickshell lockscreen installed."
echo "Bind your key to: $TARGET_DIR/lock.sh"
