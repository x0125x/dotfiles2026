#!/bin/bash

SSID=$1
PASS=$2

eww update auth_error=""

if [ -z "$PASS" ]; then
    ERROR=$(nmcli dev wifi connect "$SSID" 2>&1)
else
    ERROR=$(nmcli dev wifi connect "$SSID" password "$PASS" 2>&1)
fi

if [ $? -eq 0 ]; then
    eww close wifi_auth
    eww update auth_pass="" auth_error=""
else
    if echo "$ERROR" | grep -iq "Secrets were required"; then
        eww update auth_error="Password Required"
    else
        eww update auth_error="Connection Failed"
    fi
fi
