#!/usr/bin/env zsh
dbus-monitor --session "type='signal',interface='org.gnome.ScreenSaver',member='ActiveChanged'" | while read type value   
do
if [ x"$type" = x"boolean" ]; then
    echo "core.weechat *${value}" > ~/.weechat/weechat_fifo*
fi
done
