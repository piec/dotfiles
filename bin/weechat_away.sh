#!/usr/bin/env zsh
if [ x"$1" =  x"1" ] || [ x"$1" = x"true" ]; then
    cmd="/away -all idle"
else
    cmd="/away -all"
fi
echo "core.weechat *${cmd}" > ~/.weechat/weechat_fifo*

