#!/bin/bash

set -eo pipefail

dest="$(qdbus | awk '\
	/org.mpris.MediaPlayer2.chromium.instance/ { print $1; exit }
	/org.mpris.MediaPlayer2.spotify/ { print $1; exit }
	')"

if [ "$dest" = '' ]; then
	exit 1
fi

case "$1" in
	playpause)
		dbus-send --print-reply --dest="$dest" /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
		;;

	prevtrack)
		#$XDOTOOL key --window $WINDOWID Control+Left
		dbus-send --print-reply --dest="$dest" /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous
		;;

	nexttrack)
		#$XDOTOOL key --window $WINDOWID Control+Right
		dbus-send --print-reply --dest="$dest" /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next
		;;

	*)
		echo "Usage: $0 [playpause|prevtrack|nexttrack]"
		exit 2
esac
