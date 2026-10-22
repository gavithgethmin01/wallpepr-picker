#!/bin/bash

SOCK="/tmp/mpvpaper-socket"
STATE_FILE="$HOME/.cache/livewall-current"

if [[ -f "$STATE_FILE" ]]; then
    VIDEO=$(cat "$STATE_FILE")
else
    VIDEO=""
fi

if [[ -z "$VIDEO" || ! -f "$VIDEO" ]]; then
    echo "No video selected yet. Run wallpaper-picker.sh first."
    exit 1
fi

pkill -x mpvpaper 2>/dev/null
sleep 0.4

mpvpaper -f -o "input-ipc-server=$SOCK --no-audio --loop --hwdec=auto" ALL "$VIDEO" &

for i in {1..15}; do
    [[ -S "$SOCK" ]] && break
    sleep 0.2
done

STATE="play"

while true; do
    active=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class // empty')

    if [[ -z "$active" || "$active" == "null" ]]; then
        if [[ "$STATE" != "play" ]]; then
            echo '{ "command": ["set_property", "pause", false] }' | socat - "$SOCK" >/dev/null 2>&1
            STATE="play"
        fi
    else
        if [[ "$STATE" != "pause" ]]; then
            echo '{ "command": ["set_property", "pause", true] }' | socat - "$SOCK" >/dev/null 2>&1
            STATE="pause"
        fi
    fi
    sleep 0.4
done
