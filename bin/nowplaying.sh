#!/bin/bash
set -eu
set -o pipefail
#refresh="xfce4-panel --plugin-event=genmon-16:refresh:bool:true"
# see also playerctl metadata --follow

status=$(playerctl status 2>/dev/null)

if [ "$status" = "Playing" ]; then
    playerctl metadata --format "♫ {{ title }} - {{ artist }}"
else
    echo "⏸️"   # Show nothing if not playing
fi

