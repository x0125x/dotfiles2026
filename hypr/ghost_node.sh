#!/bin/bash

ACTIVE_WORKSPACE=$(hyprctl activewindow -j | jq -r '.workspace.id')

kitty --class="ghost-node" --title="Ghost Window" sh -c "sleep infinity" &

sleep 0.1
hyprctl dispatch movetoworkspace "$ACTIVE_WORKSPACE",address:$(hyprctl clients -j | jq -r '.[] | select(.class=="ghost-node") | .address' | tail -n 1)

if [[ "$1" == "u" || "$1" == "d" ]]; then
    hyprctl dispatch layoutmsg "preselect $1"
    hyprctl dispatch movetoworkspace "$ACTIVE_WORKSPACE,address:$GHOST_ADDR"
else
    hyprctl dispatch movetoworkspace "$ACTIVE_WORKSPACE,address:$GHOST_ADDR"
    hyprctl dispatch movewindow "$1"
fi
