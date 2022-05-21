#!/bin/sh
mpv --no-config --really-quiet --no-video ~/.cache/startup.wav &

case $SHELL in
    */bash)
        [ -z "$BASH" ] && exec $SHELL $0 "$@"
        set +o posix
        . /etc/profile
        . $HOME/.profile
    ;;
    *) # Plain sh, ksh, and anything we do not know.
        . /etc/profile
        . $HOME/.profile
    ;;
esac

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for i in /etc/X11/xinit/xinitrc.d/* ; do
        if [ -x "$i" ]; then
            . "$i"
        fi
    done
fi
. $HOME/.xinitrc

# Load Xsession scripts
# OPTIONFILE, USERXSESSION, USERXSESSIONRC and ALTUSERXSESSION are required
# by the scripts to work
xsessionddir="/etc/X11/Xsession.d"
OPTIONFILE=/etc/X11/Xsession.options
USERXSESSION=$HOME/.xsession
USERXSESSIONRC=$HOME/.xsessionrc
ALTUSERXSESSION=$HOME/.Xsession

xrdb -merge $HOME/.config/X11/Xresources

if [ -z "$*" ]; then
    exec xmessage -center -buttons OK:0 -default OK "Sorry, $DESKTOP_SESSION is no valid session."
else
    exec $@ >/dev/null 2>&1
fi
