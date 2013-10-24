#!/bin/bash

# Usage: spotify-action.sh [playpause|prevtrack|nexttrack] [window-class]
# window-class defaults to 'spotify.Spotify'
#
# Copyright (C) Lee Hardy <lee -at- leeh.co.uk>
# This file is in the public domain.

if false; then
	WMCTRL="/usr/bin/wmctrl"
	XDOTOOL="/usr/bin/xdotool"

	# We need both wmctrl/xdotool to be executable
	if [ ! -x ${WMCTRL} ] || [ ! -x ${XDOTOOL} ]; then
		echo "Error: Unable to find wmctrl/xdotool"
		exit 1
	fi

	# Missing params
	if [ -z "$1" ]; then
		echo "Usage: $0 [playpause|prevtrack|nexttrack] [window-class]"
		exit 2
	fi

	# wmctrl seems a lot better than xdotool at finding spotify without also
	# finding other controls (the other xdotool finds is I presume the tray
	# icon)
	WINDOWID=$($WMCTRL -xl | awk '{if ($3 == "spotify.Spotify") { print $1 }}')
	if [ -z "$WINDOWID" ]; then
		echo "Error: Unable to find spotify window."
		echo "Hint: Run 'wmctrl -xl' -- find the spotify class in the third column "
		echo "      and pass this as [window-class]"
		exit 3
	fi
fi

case "$1" in
	playpause)
		#$XDOTOOL key --window $WINDOWID space
		dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
		;;

	prevtrack)
		#$XDOTOOL key --window $WINDOWID Control+Left
		dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous
		;;

	nexttrack)
		#$XDOTOOL key --window $WINDOWID Control+Right
		dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next
		;;

	*)
		echo "Usage: $0 [playpause|prevtrack|nexttrack]"
		exit 2
esac
