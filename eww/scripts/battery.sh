#!/bin/bash

bat=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

if [ "$status" = "Charging" ]; then
    echo "󰂄" # Charging icon
elif [ "$bat" -le 15 ]; then
    echo "󰂃" # Critical
elif [ "$bat" -le 30 ]; then
    echo "󰁻"
elif [ "$bat" -le 50 ]; then
    echo "󰁽"
elif [ "$bat" -le 70 ]; then
    echo "󰁿"
elif [ "$bat" -le 90 ]; then
    echo "󰂁"
else
    echo "󰁹"
fi
