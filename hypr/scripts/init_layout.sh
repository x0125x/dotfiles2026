#!/bin/bash

killall eww
eww daemon

MONITORS_JSON=$(hyprctl monitors -j | sed '1s/^[^[{]*//')
MONITOR_NAMES=$(echo "$MONITORS_JSON" | jq -r '.[] | .name')

WS_OFFSET=0

for MON in $MONITOR_NAMES; do
  MODEL_NAME=$(echo "$MONITORS_JSON" | jq -r ".[] | select(.name == \"$MON\") | if .model != \"\" then .model else .description end" | head -n 1 | awk '{print $1}')
  HEIGHT=$(echo "$MONITORS_JSON" | jq -r ".[] | select(.name == \"$MON\") | .height")

  START=$((WS_OFFSET + 1))
  for ((i = $START; i <= START + 4; i++)); do
    hyprctl keyword workspace "$i, monitor:$MON"
  done

  eww open bar --id "bar-$MON" --arg screen="$MODEL_NAME" --arg height="$((HEIGHT - 40))px"

  WS_OFFSET=$((WS_OFFSET + 5))
done
