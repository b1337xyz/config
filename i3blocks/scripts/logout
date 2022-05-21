#!/bin/sh
if [ $BLOCK_BUTTON -eq 1 ];then
    if [ $(printf 'Yes\nno' | dmenu -c -i -p "Logout?") = Yes ];then
        i3-msg exit
    fi
fi

