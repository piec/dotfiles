#!/bin/sh

function mouse_by_id {
    name="$1"
    f="${2:-1}"
    # evdev ---
    #f=$((1./f))
    #xinput --set-prop "$name" "Device Accel Profile" 0
    #xinput --set-prop "$name" "Device Accel Constant Deceleration" "$2"
    #xinput --set-prop "$name" "Device Accel Profile" -1

    # libinput ---
    xinput set-prop "$name" 'libinput Accel Profile Enabled' 0 1
    # z=1, libinput seems to normalize the matrix
    xinput set-prop "$name" 'Coordinate Transformation Matrix' "$f" 0 0 0 "$f" 0 0 0 1
}

function mouse {
    echo "name=$1"
    for id in $(xinput list | gawk "match(\$0, /$1\s*id=([0-9]+).*pointer/, a) { print a[1] }"); do
        echo "  id=$id val=$2"
        mouse_by_id "$id" "$2"
    done
}

function main {
    mouse "Razer Razer DeathAdder"
    mouse "Microsoft Microsoft 5-Button Mouse with IntelliEye(TM)"
    mouse "Logitech USB Optical Mouse"
    mouse "Razer Razer DeathAdder Chroma" 1
    mouse "Lenovo ThinkPad Compact USB Keyboard with TrackPoint" 1.5
    mouse "TPPS\/2 IBM TrackPoint" 1.5
}

