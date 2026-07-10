#!/usr/bin/env bash
current=$(hyprctl activeworkspace -j | jq -r '.id')
workspaces=$(hyprctl clients -j | jq -r '.[].workspace.id' | sort -u)

close_ws() {
  local ws=$1
  hyprctl dispatch "hl.dsp.focus({workspace = $ws})"
  hyprctl clients -j | jq -r ".[] | select(.workspace.id == $ws) | .address" | \
    xargs -P 0 -I {} hyprctl dispatch "hl.dsp.window.close({address = \"{}\"})"
}

for ws in $workspaces; do
  [ "$ws" = "$current" ] && continue
  close_ws "$ws"
done

close_ws "$current"
