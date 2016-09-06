#!/usr/bin/env bash
: ${XSCREENSAVER_HOOKS_DIR:=~/.config/xscreensaver-hooks.d}
if ! [ -e "${XSCREENSAVER_HOOKS_DIR}" ]; then
    echo "$0: '${XSCREENSAVER_HOOKS_DIR}' doesn\'t exist" > /dev/stderr
    exit 1
fi
xscreensaver-command -watch | while read event _; do
    case "$event" in
        LOCK|UNBLANK)
            run-parts -v --report --arg="${event}" -- "${XSCREENSAVER_HOOKS_DIR}"
            ;;
        *)
            echo "$0: unhandled event '${event}'" > /dev/stderr
            ;;
    esac
done
