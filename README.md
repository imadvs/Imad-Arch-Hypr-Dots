# 💫 Imad-Arch-Hypr-Dots

This repository is a self-contained, portable, and self-maintaining installer for my personalized Hyprland environment. It is widely compatible with Arch-based distributions (Arch, EndeavourOS, Manjaro, etc.).

## 🚀 Installation

To install this setup on a new machine:

1.  **Run the One-Line Installer:**
    ```bash
    git clone https://github.com/imadvs/Imad-Arch-Hypr-Dots.git && cd Imad-Arch-Hypr-Dots && chmod +x install.sh && ./install.sh
    ```

### Alternative: Lazy Install (`auto-install.sh`)
If you don't even want to type `git clone`, you can download just the bootstrap script:
1.  Download `auto-install.sh`.
2.  Run `chmod +x auto-install.sh && ./auto-install.sh`.
*Result: It automatically clones the repo and starts the installer.*

---

## 📜 Scripts Explained

Here is what works under the hood:

### 1. `install.sh` (The Master Installer)
This is the main entry point. It coordinates the entire installation process.
- **What it does**:
    - Checks your distro and privileges.
    - Menus allow you to select components (Hyprland, Waybar, Zsh, etc.).
    - Calls other scripts from the `install-scripts/` directory to do the heavy lifting.
    - **Driver Check**: Automatically looks for NVIDIA GPUs and installs drivers if found.

### 2. `maintain.sh` (The "Dots" Command)
This script allows this repository to act as a **two-way sync** tool.
- **Command Alias**: On installation, this script is aliased to `dots`.
- **Usage**: `dots "Optional Commit Message"`
- **What it does**:
    1.  **Pull**: Runs `git pull` to get updates from the cloud (useful if you have multiple machines).
    2.  **Sync Configs**: Copies your current settings from `~/.config` -> Repo.
    3.  **Sync Assets**: Copies your Wallpapers and Desktop Shortcuts -> Repo.
    4.  **Push**: Commits changes and pushes them to GitHub.

### 3. Key Installation Scripts (`install-scripts/`)
These scripts are called by `install.sh` but can be customized:

*   **`01-hypr-pkgs.sh`**:
    *   Installs core Hyprland packages (waybar, rofi, kitty, etc.).
    *   **Customization**: This file contains the `Extra=(...)` list where your personal apps (`obsidian`, `brave-bin`, `vscode`) are defined for auto-installation.
*   **`zsh.sh`**:
    *   Installs Zsh and Oh-My-Zsh.
    *   **Auto-Injection**: Automatically adds the `dots` command to your `.zshrc` so you can start managing your repo immediately.
*   **`sddm_theme.sh`**:
    *   Installs your custom `sddm-astronaut-theme`.
    *   **Fixes**: Applies 4K HiDPI scaling and sets the correct `pixel_sakura` preset.
*   **`dotfiles-main.sh`**:
    *   Responsible for copying the `Hyprland-Dots` (configs) and `wallpapers` to your system.
    *   It triggers `Hyprland-Dots/copy.sh`.

### 4. `Hyprland-Dots/copy.sh`
This script does the actual file copying during installation.
- It copies specific folders (`hypr`, `waybar`, etc.) from the repo to `~/.config`.
- It restores your **Wallpapers** to `~/Pictures/wallpapers`.
- It restores your **Web Apps** to `~/.local/share/applications`.

---

## ✨ Features Overview

*   **Portable**: All customized installation scripts use local files (bundled in the repo), so no external GitHub cloning is required for themes or dots.
*   **Self-Updating**: The `maintain.sh` script ensures your repo always matches your local machine.
*   **Large File Support**: Configured with Git LFS to handle high-res themes and assets.
*   **Custom Apps**: Automatically restores your browser web apps and desktop shortcuts.

---

## 🔄 How to Update

**Scenario A: You changed a setting (keybind, wallpaper, etc.)**
Run:
```bash
dots "Updated keybinds"
```
*Result: Local changes -> Repo -> GitHub.*

**Scenario B: You are on a NEW machine**
Run:
```bash
cd Imad-Arch-Hypr-Dots
git pull
./install.sh
```
*Result: GitHub -> Repo -> Local Machine.*

## ↩️ How to Undo / Rollback

If you messed up a configuration and want to go back to a previous version:

1.  **Go to the repo:**
    ```bash
    cd ~/Imad-Arch-Hypr-Dots
    ```
2.  **Find the "Good" commit:**
    ```bash
    git log --oneline
    ```
    *(Copy the code, e.g., `a1b2c3d`, of the version you want).*
3.  **Reset the repo to that version:**
    ```bash
    git reset --hard <commit-hash>
    ```
4.  **Re-apply the good configs:**
    ```bash
    ./install.sh
    ```
    *(Select "y" to overwrite configs).*
