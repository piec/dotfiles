#!/bin/sh
set -x

function mouse {
    #xinput --set-prop "$1" "Device Accel Profile" 0
    #xinput --set-prop "$1" "Device Accel Constant Deceleration" "$2"
    #xinput --set-prop "$1" "Device Accel Profile" -1
    xinput set-prop "$1" 'libinput Accel Profile Enabled' 0 1
}

function mouse_by_name {
    id=$(xinput list --id-only "$1")
    [ "$?" = 0 ] && mouse "$id" "$2"
}

function main {
    mouse_by_name "Razer Razer DeathAdder" 5
    mouse_by_name "Microsoft Microsoft 5-Button Mouse with IntelliEye(TM)" 1
    mouse_by_name "Logitech USB Optical Mouse" 1
    mouse_by_name "Razer Razer DeathAdder Chroma" 5
}

