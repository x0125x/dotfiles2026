#!/bin/bash

is_occupied() {
    hyprctl workspaces -j | jq -e ".[] | select(.id == $1)" > /dev/null
}

is_focused() {
    hyprctl monitors -j | jq -e ".[] | select(.focused == true) and .activeWorkspace.id == $1" > /dev/null
}

generate_workspaces() {
    echo -n "(box :class \"works\" :orientation \"v\" :spacing 8 :space-evenly \"false\" "
    
    for i in {1..5}; do
        if is_focused $i; then
            echo -n "(button :class \"ws-active\" :onclick \"hyprctl dispatch workspace $i\" \"\") "
        elif is_occupied $i; then
            echo -n "(button :class \"ws-occupied\" :onclick \"hyprctl dispatch workspace $i\" \"\") "
        else
	    echo -n "(button :class \"ws-empty\" :onclick \"hyprctl dispatch workspace $i\" \"•\") "
        fi
    done
    echo ")"
}

generate_workspaces
socat -u "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | while read -r line; do
    generate_workspaces
done
