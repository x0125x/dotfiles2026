#!/bin/bash

eww close-all

bspc query -M --names | while read -r name; do
    height=$(xrandr --query | grep "^$name" | grep -o "[0-9]\+x[0-9]\+" | cut -d'x' -f2)
    eww open bar --id "bar_$name" --arg screen="$name" --arg height="$(($height - 40))px"
done
