#!/bin/bash
set -eu
set -o pipefail
status=$(playerctl status 2>/dev/null)

if [ "$status" = "Playing" ]; then
    playerctl metadata --format "♫ {{ title }} - {{ artist }}"
else
    echo "⏸️"   # Show nothing if not playing
fi

