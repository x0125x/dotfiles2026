#!/bin/bash

known_networks=$(nmcli -g 802-11-wireless.ssid connection show)
networks=$(nmcli -t -f "SSID,SIGNAL,SECURITY,ACTIVE" dev wifi list | sed 's/\\:/-/g')

echo "(box :orientation 'v' :space-evenly false :class 'wifi-list-box'"

echo "$networks" | while IFS=: read -r ssid signal security active; do
    if [ -n "$ssid" ]; then
        [ "$signal" -gt 75 ] && icon="󰤨" || [ "$signal" -gt 50 ] && icon="󰤥" || [ "$signal" -gt 25 ] && icon="󰤢" || icon="󰤟"
        
        if [ "$signal" -gt 70 ]; then
            sig_class="sig-high"
        elif [ "$signal" -gt 35 ]; then
            sig_class="sig-med"
        else
            sig_class="sig-low"
        fi

        [ "$active" = "yes" ] && class="wifi-active" || class="wifi-item"

        if echo "$known_networks" | grep -qx "$ssid"; then
            cmd="nmcli dev wifi connect \"$ssid\" &"
        else
            cmd="eww update auth_ssid=\"$ssid\" auth_pass=\"\" auth_error=\"\" && eww open --toggle wifi_auth"
        fi
        
        echo "  (button :class '$class' :onclick '$cmd' "
        echo "    (box :space-evenly false (label :text '$icon ' :class 'wifi-icon $sig_class') (label :text '$ssid')))"
    fi
done

echo ")"
