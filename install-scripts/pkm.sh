#!/bin/bash
# PKM (Personal Knowledge Management) Setup
# Clones the PKM repo and configures Obsidian Git plugin

LOG="Install-Logs/install-$(date +%d-%H%M%S)_pkm.log"

printf "\n%s - Setting up PKM (Obsidian Vault)...\n" "${NOTE}"

# 1. Set git identity globally
git config --global user.email "imadvs00@gmail.com"
git config --global user.name "imadvs"
echo "  Git identity set." | tee -a "$LOG"

# 2. Ensure gh CLI is logged in
if ! gh auth status &>/dev/null; then
  echo "${WARN} GitHub CLI not authenticated. Please run: gh auth login" | tee -a "$LOG"
  echo "${WARN} Then re-run this script." | tee -a "$LOG"
  exit 1
fi
echo "  GitHub CLI authenticated." | tee -a "$LOG"

# 3. Set gh as git credential helper
gh auth setup-git

# 4. Clone PKM repo to ~/Documents
PKM_DIR="$HOME/Documents/PKM"
if [ -d "$PKM_DIR/.git" ]; then
  echo "  PKM repo already exists. Pulling latest..." | tee -a "$LOG"
  git -C "$PKM_DIR" pull
else
  echo "  Cloning PKM repo..." | tee -a "$LOG"
  mkdir -p "$HOME/Documents"
  git clone https://github.com/imadvs/PKM.git "$PKM_DIR"
fi

# 5. Ensure remote is HTTPS (works with gh credential helper)
git -C "$PKM_DIR" remote set-url origin https://github.com/imadvs/PKM.git

# 6. Create .obsidian directory if missing
mkdir -p "$PKM_DIR/.obsidian/plugins/obsidian-git"

# 7. Write Obsidian Git plugin config for auto-sync
cat > "$PKM_DIR/.obsidian/plugins/obsidian-git/data.json" << 'OBSIDIAN_GIT_JSON'
{
  "commitMessage": "vault backup: {{date}}",
  "commitDateFormat": "YYYY-MM-DD HH:mm:ss",
  "autoSaveInterval": 1,
  "autoPushInterval": 30,
  "autoPullInterval": 30,
  "autoPullOnBoot": true,
  "disablePush": false,
  "pullBeforePush": true,
  "disablePopups": false,
  "disablePopupsForNoChanges": false,
  "listChangedFilesInMessageBody": false,
  "showStatusBar": true,
  "updateSubmodules": false,
  "syncMethod": "merge",
  "customMessageOnAutoBackup": false,
  "autoBackupAfterFileChange": true,
  "treeStructure": false,
  "refreshSourceControl": true,
  "basePath": "",
  "differentIntervalCommitAndPush": false,
  "changedFilesInStatusBar": false,
  "showedMobileNotice": true,
  "refreshSourceControlTimer": 7000,
  "showBranchStatusBar": true,
  "setLastSaveToLastCommit": false,
  "submoduleRecurseCheckout": false,
  "gitDir": "",
  "showFileMenu": true,
  "authorInHistoryView": "hide",
  "dateInHistoryView": false,
  "diffStyle": "split",
  "lineAuthor": {
    "show": false,
    "followMovement": "inactive",
    "authorDisplay": "initials",
    "showCommitHash": false,
    "dateTimeFormatOptions": "date",
    "dateTimeFormatCustomString": "YYYY-MM-DD HH:mm",
    "dateTimeTimezone": "viewer-local",
    "coloringMaxAge": "1y",
    "colorNew": { "r": 255, "g": 150, "b": 150 },
    "colorOld": { "r": 120, "g": 160, "b": 255 },
    "textColorCss": "var(--text-muted)",
    "ignoreWhitespace": false,
    "gutterSpacingFallbackLength": 5,
    "lastShownAuthorDisplay": "initials",
    "lastShownDateTimeFormatOptions": "date"
  },
  "autoCommitMessage": "vault backup: {{date}}"
}
OBSIDIAN_GIT_JSON
echo "  Obsidian Git plugin configured." | tee -a "$LOG"

# 8. Verify setup
echo "  Verifying..." | tee -a "$LOG"
git -C "$PKM_DIR" remote -v | tee -a "$LOG"
echo "  PKM setup complete." | tee -a "$LOG"
