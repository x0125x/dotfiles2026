#!/bin/bash

vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]+(?=%)' | head -n 1)
mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

if [ "$mute" = "yes" ]; then
    icon="󰝟"
    class="vol-muted"
elif [ -z "$vol" ]; then
    icon="󰝟"
    class="vol-muted"
elif [ "$vol" -le 30 ]; then
    icon="󰕿"
    class="vol-low"
elif [ "$vol" -le 60 ]; then
    icon="󰖀"
    class="vol-mid"
else
    icon="󰕾"
    class="vol-high"
fi

echo "(label :text '$icon' :class '$class')"
