#!/bin/bash
# DigitalZen Installer
# Downloads and sets up DigitalZen AppImage on Arch Linux

source install-scripts/Global_functions.sh

LOG="Install-Logs/install-$(date +%d-%H%M%S)_digitalzen.log"

APP_NAME="DigitalZen"
INSTALL_DIR="$HOME/.local/bin"
ICON_DIR="$HOME/.local/share/icons"
DESKTOP_DIR="$HOME/.local/share/applications"
AUTOSTART_DIR="$HOME/.config/autostart"
APPIMAGE_URL="https://downloads.digitalzen.app/stable/DigitalZen.AppImage"

# 1. Ensure fuse2 is installed (required for AppImages)
install_package_pacman "fuse2"

# 2. Create directories
mkdir -p "$INSTALL_DIR" "$ICON_DIR" "$DESKTOP_DIR" "$AUTOSTART_DIR"

# 3. Download AppImage (skip if exists)
APPIMAGE_PATH="$INSTALL_DIR/$APP_NAME.AppImage"
if [ -f "$APPIMAGE_PATH" ]; then
    echo "${INFO} $APP_NAME AppImage already installed. Skipping download." | tee -a "$LOG"
else
    echo "${INFO} Downloading $APP_NAME AppImage..." | tee -a "$LOG"
    curl -L --progress-bar -o "$APPIMAGE_PATH" "$APPIMAGE_URL"
    chmod +x "$APPIMAGE_PATH"
    echo "${OK} $APP_NAME AppImage installed to $APPIMAGE_PATH" | tee -a "$LOG"
fi

# 4. Download icon
ICON_PATH="$ICON_DIR/$APP_NAME.svg"
echo "${INFO} Downloading $APP_NAME icon..." | tee -a "$LOG"
ICON_HREF=$(curl -s "https://my.digitalzen.app" | grep -oP '(?<=<link rel="icon" href=")[^"]+\.svg')
if [[ -n "$ICON_HREF" ]]; then
    if [[ "$ICON_HREF" == /* ]]; then
        ICON_HREF="https://my.digitalzen.app$ICON_HREF"
    fi
    curl -s -L -o "$ICON_PATH" "$ICON_HREF"
    echo "${OK} Icon saved to $ICON_PATH" | tee -a "$LOG"
else
    echo "${WARN} Could not fetch icon URL. Skipping icon download." | tee -a "$LOG"
fi

# 5. Create desktop entry
cat > "$DESKTOP_DIR/$APP_NAME.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=$APP_NAME
Exec=$APPIMAGE_PATH
Icon=$ICON_PATH
Terminal=false
StartupNotify=true
Categories=Utility;Productivity;
X-AppImage-Integrate=false
EOF
echo "${OK} Desktop entry created at $DESKTOP_DIR/$APP_NAME.desktop" | tee -a "$LOG"

# 6. Create autostart shortcut
ln -sf "$DESKTOP_DIR/$APP_NAME.desktop" "$AUTOSTART_DIR/$APP_NAME.desktop"
echo "${OK} Autostart shortcut created at $AUTOSTART_DIR/$APP_NAME.desktop" | tee -a "$LOG"

# 7. Update desktop database
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
fi

echo "" | tee -a "$LOG"
echo "${OK} ${MAGENTA}$APP_NAME${RESET} installation complete!" | tee -a "$LOG"
echo "" | tee -a "$LOG"
