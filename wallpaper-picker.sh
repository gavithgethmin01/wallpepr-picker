#!/bin/bash

# Videos folder (absolute path)
DIR="$HOME/Videos/LiveWallpapers"

ENGINE="$HOME/.local/bin/wallpaper-engine.sh"
STATE_FILE="$HOME/.cache/livewall-current"

ROFI="rofi"
FIND="find"
BASENAME="basename"

# Video list
mapfile -t FILES < <($FIND "$DIR" -maxdepth 1 -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) | sort)

if [[ ${#FILES[@]} -eq 0 ]]; then
    notify-send "LiveWall" "No videos found in $DIR" 2>/dev/null
    echo "No videos found in: $DIR"
    exit 1
fi

OPTIONS=""
for f in "${FILES[@]}"; do
    OPTIONS+="$($BASENAME "$f")"$'\n'
done

CHOICE=$(echo -n "$OPTIONS" | $ROFI -dmenu -i -p "LiveWall")

[[ -z "$CHOICE" ]] && exit 0

SELECTED=""
for f in "${FILES[@]}"; do
    if [[ "$($BASENAME "$f")" == "$CHOICE" ]]; then
        SELECTED="$f"
        break
    fi
done

[[ -z "$SELECTED" ]] && exit 1

mkdir -p "$(dirname "$STATE_FILE")"
echo "$SELECTED" > "$STATE_FILE"

pkill -x mpvpaper 2>/dev/null
pkill -f "wallpaper-engine.sh" 2>/dev/null
sleep 0.4

nohup bash "$ENGINE" >/dev/null 2>&1 &

exit 0
