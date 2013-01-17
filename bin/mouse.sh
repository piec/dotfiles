set -xe
[ x"$1" != x ]
id="$1"
xinput --set-prop $id "Device Accel Profile" 0
xinput --set-prop $id "Device Accel Constant Deceleration" ${2-6}
xinput --set-prop $id "Device Accel Profile" -1

