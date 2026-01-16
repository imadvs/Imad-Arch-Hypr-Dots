#!/bin/bash
# Custom SDDM Theme Installer for Imad-Arch-Hypr-Dots
# Installs the preserved sddm-astronaut-theme with pixel_sakura and HiDPI fixes

LOG="Install-Logs/install-$(date +%d-%H%M%S)_sddm_theme.log"
THEME_NAME="sddm-astronaut-theme"
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
# Create/Update /etc/sddm.conf
if [ ! -f /etc/sddm.conf ]; then
    sudo touch /etc/sddm.conf
fi

# Ensure [Theme] section exists and set Current theme
if grep -q "^\[Theme\]" /etc/sddm.conf; then
    sudo sed -i "s/^Current=.*/Current=$THEME_NAME/" /etc/sddm.conf
else
    echo -e "\n[Theme]\nCurrent=$THEME_NAME" | sudo tee -a /etc/sddm.conf
fi

# Ensure [General] section exists and input method is set
if grep -q "^\[General\]" /etc/sddm.conf; then
     # Check if InputMethod exists, if so replace it, else append it
    if grep -q "InputMethod=" /etc/sddm.conf; then
        sudo sed -i "s/^InputMethod=.*/InputMethod=qtvirtualkeyboard/" /etc/sddm.conf
    else
         sudo sed -i "/^\[General\]/a InputMethod=qtvirtualkeyboard" /etc/sddm.conf
    fi
else
    echo -e "\n[General]\nInputMethod=qtvirtualkeyboard" | sudo tee -a /etc/sddm.conf
fi

echo "SDDM Theme installation complete."
