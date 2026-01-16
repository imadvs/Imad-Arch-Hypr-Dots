#!/bin/bash

# 1. Get the current active workspace ID
ACTIVE_WS=$(hyprctl activeworkspace -j | jq '.id')

# 2. Get the 'address' of every window on that workspace
# 3. Tell Hyprland to close each of those addresses specifically
hyprctl clients -j | jq -r ".[] | select(.workspace.id == $ACTIVE_WS) | .address" | while read -r addr; do
    hyprctl dispatch closewindow address:"$addr"
done
