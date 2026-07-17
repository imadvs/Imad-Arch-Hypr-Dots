#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Initialize J/K keybinds so they always cycle windows globally (no layout-specific behavior)
# This avoids double-actions when layouts change.

set -euo pipefail

# Cycle windows globally: J = next, K = previous
hyprctl eval 'hl.bind("SUPER + J", hl.dsp.layout("cyclenext"))'
hyprctl eval 'hl.bind("SUPER + K", hl.dsp.layout("cyclenext", "prev"))'
