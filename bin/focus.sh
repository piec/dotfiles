#!/bin/bash
set -x
set -e

err () {
	echo "$1"
	exit 1
}

[ a$1 != a ] || err "\$1 empty"

active=`xdotool getactivewindow` 
if [[ "$1" =~ (^[[:digit:]]*$) ]] ; then
	window_id=$1
else
	window_id=`xdotool search --all --desktop 0 --name $1 | head -n 1`
fi

if [ "a$window_id" != "a" ]; then
	xdotool windowactivate $window_id
fi

