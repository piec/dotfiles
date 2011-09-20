#/usr/bin/env bash
set -x
set -e
touch /tmp/mdrlol
echo $* > /tmp/mdrlol
[ a$1 != a ] || (echo "\$1 empty"; exit 1)
active=`xdotool getactivewindow` 
if [[ $1 =~ (^[[:digit:]]*$) ]]; then
	window_id=$1
else
	window_id=`xdotool search --all --desktop 0 --name $1`
fi

if [ a$active == a$window_id ]; then
	xdotool windowminimize $active
else
	xdotool windowactivate $window_id
fi

