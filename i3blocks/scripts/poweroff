#!/bin/sh
if [ $BLOCK_BUTTON -eq 1 ];then
    if [ $(printf 'Yes\nno' | dmenu -i -c -p "Poweroff?") = Yes ];then
        shutdown -P 1 2>&1 | xargs -I{} notify-send {}
    fi
fi

