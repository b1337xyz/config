#!/usr/bin/env bash
# mpv --no-config --really-quiet --no-video ~/.cache/startup.wav &

[ -z "$BASH" ] && exec $SHELL $0 "$@"
set +o posix
. /etc/profile
. "$HOME/.profile"

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for i in /etc/X11/xinit/xinitrc.d/*
    do
        [ -x "$i" ] && . "$i"
    done
fi
. "$HOME/.xinitrc"

# OPTIONFILE, USERXSESSION, USERXSESSIONRC and ALTUSERXSESSION are required
# by the scripts to work
xsessionddir=/etc/X11/Xsession.d
OPTIONFILE=/etc/X11/Xsession.options
USERXSESSION="$HOME/.xsession"
USERXSESSIONRC="$HOME/.xsessionrc"
ALTUSERXSESSION="$HOME/.Xsession"

xrdb -merge "$HOME/.config/X11/Xresources"

if [ -z "$*" ]; then
    exec xmessage -center -buttons OK:0 -default OK \
        "Sorry, $DESKTOP_SESSION is no valid session."
else
    exec $@ >/dev/null 2>&1
fi
