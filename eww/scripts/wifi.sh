#!/bin/bash

signal=$(nmcli -g IN-USE,SIGNAL dev wifi | grep '*' | cut -d':' -f2)

if [ -z "$signal" ]; then
    echo "(label :text '󰤮' :class 'sig-none')"
    exit 0
fi

if [ "$signal" -le 25 ]; then
    icon="󰤟"
    class="sig-low"
elif [ "$signal" -le 50 ]; then
    icon="󰤢"
    class="sig-med"
elif [ "$signal" -le 75 ]; then
    icon="󰤥"
    class="sig-med"
else
    icon="󰤨"
    class="sig-high"
fi

echo "(label :text '$icon' :class '$class')"
