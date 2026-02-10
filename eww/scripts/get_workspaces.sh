#!/bin/bash

build_monitor_yuck() {
  local port=$1
  local start_ws=$2
  local mon_data=$3
  local ws_data=$4
  local end_ws=$((start_ws + 4))

  local yuck="(box :class \"works\" :orientation \"v\" :spacing 8 :space-evenly false "

  for ((i = start_ws; i <= end_ws; i++)); do
    local focused=$(echo "$mon_data" | jq -e ".[] | select(.name == \"$port\") | .activeWorkspace.id == $i" >/dev/null && echo "true" || echo "false")
    local occupied=$(echo "$ws_data" | jq -e ".[] | select(.id == $i) | .windows > 0" >/dev/null && echo "true" || echo "false")

    local class="ws-idle"
    local symbol="•"
    if [ "$focused" == "true" ]; then
      class="ws-active"
      symbol=""
    elif [ "$occupied" == "true" ]; then
      class="ws-occupied"
      symbol=""
    fi

    yuck+="(eventbox :cursor \"pointer\" "
    yuck+="(button :class \"$class\" :onclick \"hyprctl dispatch workspace $i\" \"$symbol\")) "
  done

  yuck+=")"
  echo "$yuck"
}

generate_json() {
  local mon_json=$(hyprctl monitors -j)
  local ws_json=$(hyprctl workspaces -j)

  local ports=$(echo "$mon_json" | jq -r '.[] | .name')

  local json_output="{"
  local first=true
  local ws_offset=1

  for port in $ports; do
    if [ "$first" = false ]; then json_output+=","; fi

    local screen_name=$(echo "$mon_json" | jq -r ".[] | select(.name == \"$port\") | if .model != \"\" then .model else .description end" | head -n 1 | awk '{print $1}')
    local yuck_content=$(build_monitor_yuck "$port" "$ws_offset" "$mon_json" "$ws_json")
    local escaped_yuck=$(echo "$yuck_content" | sed 's/"/\\"/g')

    json_output+="\"$screen_name\": \"$escaped_yuck\""

    ws_offset=$((ws_offset + 5))
    first=false
  done

  json_output+="}"
  echo "$json_output"
}

generate_json
socat -u "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | while read -r line; do
  generate_json
done
