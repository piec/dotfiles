#!/bin/sh

function mouse_by_id {
    local id="$1"
    local f="${2:-1}"
    local profile_a="${3:-0}"
    local profile_b="${4:-1}"
    # evdev ---
    #f=$((1./f))
    #xinput --set-prop "$id" "Device Accel Profile" 0
    #xinput --set-prop "$id" "Device Accel Constant Deceleration" "$2"
    #xinput --set-prop "$id" "Device Accel Profile" -1

    # libinput ---
    xinput set-prop "$id" 'libinput Accel Profile Enabled' "$profile_a" "$profile_b"
    # z=1, libinput seems to normalize the matrix
    xinput set-prop "$id" 'Coordinate Transformation Matrix' "$f" 0 0 0 "$f" 0 0 0 1
}

function mouse {
    name="$1"
    echo "name=$name"
    shift
    for id in $(xinput list | gawk "match(\$0, /${name}\s*id=([0-9]+).*pointer/, a) { print a[1] }"); do
        echo "  id=$id val=$1"
        mouse_by_id "$id" $*
    done
}

function main {
    mouse "Razer Razer DeathAdder"
    mouse "Microsoft Microsoft 5-Button Mouse with IntelliEye(TM)"
    mouse "Logitech USB Optical Mouse"
    mouse "Razer Razer DeathAdder Chroma" 1
    mouse "Lenovo ThinkPad Compact USB Keyboard with TrackPoint" 2.0
    mouse "TPPS\/2 IBM TrackPoint" 1.3
    mouse "TPPS\/2 Elan TrackPoint" 1.5
    mouse "SynPS\/2 Synaptics TouchPad" 2.0 1 0
    mouse "Logitech G403 Prodigy Gaming Mouse" 1
    mouse "Logitech Gaming Mouse G402" 1
}

main
