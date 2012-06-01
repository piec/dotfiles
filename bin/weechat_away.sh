#!/usr/bin/env zsh
dbus-monitor --session "type='signal',interface='org.gnome.ScreenSaver',member='ActiveChanged'" | while read type value   
do
if [ x"$type" = x"boolean" ]; then
    [ x"$value" =  x"true" ] && cmd="/away -all idle" || cmd="/away -all"
    echo "core.weechat *${cmd}" > ~/.weechat/weechat_fifo*                                                                                                     
fi
done
