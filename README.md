# My Custom Hyprland Dotfiles

This repository is a self-contained, portable installer for my personalized Hyprland environment. It is based on Jakoolit's scripts but modified to be deeply customized and completely independent.

## 🚀 Installation

To install this setup on any Arch-based system (Arch, EndeavourOS, Manjaro, etc.):

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/YOUR_USERNAME/My-Hyprland.git
    cd My-Hyprland
    ```

2.  **Run the installer:**
    ```bash
    ./install.sh
    ```

### What happens during installation?
- **Packages**: Installs Hyprland, Waybar, Rofi, Kitty, and **your custom apps** (`obsidian`, `brave-bin`, `visual-studio-code-bin`).
- **Configs**: Restores your exact configurations for 17+ tools (AgS, Neovim, Qt5/6, etc.).
- **Themes**: Installs the `sddm-astronaut-theme` with your `pixel_sakura` preset and 4K HiDPI fixes.
- **Assets**: Restores your full wallpaper collection to `~/Pictures/wallpapers`.
- **Web Apps**: Restores your custom web apps (`youtube-music`, `pomofocus`, `programming-advices`).
- **Shell**: Restores your `.zshrc` so your terminal feels right at home immediately.

---

## ✨ Features

### 📦 Complete Configuration Support
This repo syncs and restores configurations for:
- `ags`, `btop`, `cava`, `fastfetch`
- `hypr` (Keybinds, WindowRules, Monitors)
- `kitty`, `Kvantum`, `nvim`, `qt5ct/qt6ct`
- `quickshell`, `rofi`, `swappy`, `swaync`
- `wallust`, `waybar`, `wlogout`

### 🎨 Custom Theming
- **SDDM**: Preserves your `pixel_sakura` theme with specific high-resolution scaling fixes.
- **Wallpapers**: Your personal collection is bundled in `Hyprland-Dots/wallpapers` and restored automatically.

### 🛠️ Utilities
- **Web Apps**: Custom `.desktop` entries for Brave web apps are preserved.
- **Driver Support**: Automatically detects NVIDIA GPUs and prompts for driver installation.
- **Distro Agnostic**: Works on any Arch-based distribution.

---

## 🔄 Maintenance & Updates

This repository comes with a powerful sync script to keep it up-to-date with your local changes.

**If you make changes to your system** (e.g., new keybinds, new wallpapers, new config tweaks), simply run:

```bash
~/update_my_dots.sh
```

This script will:
1.  Recursively sync all relevant config folders from `~/.config` to the repo.
2.  Sync new wallpapers from `~/Pictures/wallpapers`.
3.  Sync new desktop shortcuts from `~/.local/share/applications`.

After running it, just `git push` your changes!

---

## 📂 Repository Structure

- `Hyprland-Dots/config`: The core configuration files.
- `Hyprland-Dots/wallpapers`: Your wallpaper collection.
- `assets/applications`: Backup of custom `.desktop` files.
- `assets/sddm-astronaut-theme`: Your modified login screen theme.
- `install-scripts/`: The installation logic (Sanitized to use local files only).
