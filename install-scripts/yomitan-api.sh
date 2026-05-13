#!/bin/bash
# 💫 Yomitan API Installer 💫
# Sets up the Yomitan API native messaging host for Chrome and Brave
# so that Asbplayer can communicate with Yomitan for dictionary lookups.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_DIR="$SCRIPT_DIR/../assets/yomitan-api"
INSTALL_DIR="$HOME/yomitan-api"

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
RESET="$(tput sgr0)"
MAGENTA="$(tput setaf 5)"

echo ""
echo "${INFO} Setting up ${MAGENTA}Yomitan API${RESET} for Asbplayer integration..."
echo ""

# 1. Create install directory and copy scripts
mkdir -p "$INSTALL_DIR"
if cp "$ASSETS_DIR/yomitan_api.py" "$INSTALL_DIR/yomitan_api.py" && \
   cp "$ASSETS_DIR/yomitan_api_wrapper.sh" "$INSTALL_DIR/yomitan_api_wrapper.sh"; then
    echo "${OK} Yomitan API scripts copied to $INSTALL_DIR"
else
    echo "${ERROR} Failed to copy Yomitan API scripts"
    exit 1
fi

# 2. Make scripts executable
chmod +x "$INSTALL_DIR/yomitan_api.py"
chmod +x "$INSTALL_DIR/yomitan_api_wrapper.sh"
echo "${OK} Scripts marked as executable"

# 3. Generate the manifest with the correct path
WRAPPER_PATH="$INSTALL_DIR/yomitan_api_wrapper.sh"
MANIFEST=$(cat <<EOF
{
    "name": "yomitan_api",
    "description": "Yomitan API",
    "type": "stdio",
    "path": "$WRAPPER_PATH",
    "allowed_origins": [
        "chrome-extension://likgccmbimhjbgkjambclfkhldnlhbnn/",
        "chrome-extension://hkjbmjjhhdhncajmcbhbnebiidohihon/"
    ]
}
EOF
)

# 4. Install manifest for Chrome
CHROME_DIR="$HOME/.config/google-chrome/NativeMessagingHosts"
mkdir -p "$CHROME_DIR"
echo "$MANIFEST" > "$CHROME_DIR/yomitan_api.json"
echo "${OK} Manifest installed for Google Chrome"

# 5. Install manifest for Brave
BRAVE_DIR="$HOME/.config/BraveSoftware/Brave-Browser/NativeMessagingHosts"
mkdir -p "$BRAVE_DIR"
echo "$MANIFEST" > "$BRAVE_DIR/yomitan_api.json"
echo "${OK} Manifest installed for Brave Browser"

# 6. Install to system-wide Chrome path if possible (improves compatibility)
SYSTEM_CHROME_DIR="/etc/opt/chrome/native-messaging-hosts"
if [ -d "$SYSTEM_CHROME_DIR" ] || sudo mkdir -p "$SYSTEM_CHROME_DIR" 2>/dev/null; then
    echo "$MANIFEST" | sudo tee "$SYSTEM_CHROME_DIR/yomitan_api.json" > /dev/null 2>&1 && \
        echo "${OK} Manifest installed system-wide for Chrome" || \
        echo "${NOTE} Could not install system-wide manifest (optional, skipping)"
fi

echo ""
echo "${OK} ${MAGENTA}Yomitan API${RESET} installation complete!"
echo ""
echo "${INFO} Next steps:"
echo "  1. Restart Chrome or Brave"
echo "  2. Open Yomitan Settings → General → Enable Yomitan API"
echo "  3. Click 'Test' to verify the connection"
echo "  4. In Asbplayer Settings → Annotation → set Yomitan API URL to: http://127.0.0.1:19633"
echo ""
