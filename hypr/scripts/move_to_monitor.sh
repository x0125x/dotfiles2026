#!/bin/bash

CURRENT_WS=$(hyprctl activeworkspace -j | jq '.id')

MONITOR_COUNT=$(hyprctl monitors -j | jq '. | length')

TOTAL_WORKSPACES=$((MONITOR_COUNT * 5))

OFFSET=5

if [ "$1" == "next" ]; then
  TARGET=$((CURRENT_WS + OFFSET))
  if [ $TARGET -gt $TOTAL_WORKSPACES ]; then
    TARGET=$((TARGET % TOTAL_WORKSPACES))
    [ $TARGET -eq 0 ] && TARGET=$TOTAL_WORKSPACES
  fi
elif [ "$1" == "prev" ]; then
  TARGET=$((CURRENT_WS - OFFSET))
  if [ $TARGET -lt 1 ]; then
    TARGET=$((TOTAL_WORKSPACES + TARGET))
  fi
fi

hyprctl dispatch movetoworkspace $TARGET
