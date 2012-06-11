#!/bin/bash

set -x

to=$1
screen=$2

res_w=`xdotool getdisplaygeometry | cut -d" " -f1` 
res_h=`xdotool getdisplaygeometry | cut -d" " -f2` 
echo $res_w
echo $res_h

mouse_x=`xdotool getmouselocation | grep --only-matching "x:[0-9]*" | cut -d":" -f2`
mouse_y=`xdotool getmouselocation | grep --only-matching "y:[0-9]*" | cut -d":" -f2`
echo $mouse_x
echo $mouse_y

if [ $mouse_x -lt $res_w ]; then
	screen=0
else
	screen=1
fi

echo $screen

bar=24

x=0
y=$bar
w=960
h=$[ $res_h - 2 * $bar - 24 ]

name=`xdotool getactivewindow getwindowname`
#if echo $name | grep -i term; then
#	h=1015
#fi

if [ $screen = "1" ]; then
	x=$[ $x + 1920 ]
fi

if [ $to = "right" ]; then
	x=$[ $x + 960 ]
fi

xdotool getactivewindow windowmove $x $y windowsize $w $h
xdotool getactivewindow windowraise

