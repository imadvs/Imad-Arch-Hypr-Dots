#!/bin/bash
# Custom SDDM Theme Installer for Imad-Arch-Hypr-Dots
# Installs the preserved The Last of Us theme

LOG="Install-Logs/install-$(date +%d-%H%M%S)_sddm_theme.log"
THEME_NAME="last-of-us"
THEME_DIR="/usr/share/sddm/themes"

echo "Installing Custom SDDM Theme..."

# 1. Copy Theme
if [ -d "assets/$THEME_NAME" ]; then
    echo "Copying $THEME_NAME to $THEME_DIR..."
    sudo cp -r "assets/$THEME_NAME" "$THEME_DIR/" 2>&1 | tee -a "$LOG"
else
    echo "Error: Theme assets not found!" | tee -a "$LOG"
    exit 1
fi

# 2. Enable HiDPI
echo "Enabling HiDPI support..."
echo "[General]
EnableHiDPI=true" | sudo tee /etc/sddm.conf.d/hidpi.conf > /dev/null

# 3. Configure SDDM to use the theme
echo "Configuring SDDM to use $THEME_NAME..."
CONFIG_SRC="config/etc/sddm.conf"
if [ -f "$CONFIG_SRC" ]; then
    echo "Copying SDDM config from repo..."
    sudo cp "$CONFIG_SRC" /etc/sddm.conf
else
    echo "No repo config found, creating inline..."
    sudo tee /etc/sddm.conf > /dev/null <<'EOF'
[Theme]
Current=last-of-us

[General]
InputMethod=qtvirtualkeyboard
EOF
fi

echo "SDDM Theme installation complete."
