#!/bin/sh
# shellcheck disable=SC2035

set -e

cd ~/.local/share/qutebrowser/userscripts
script=$(command ls -1 *.sh *.py | grep -v "${0##*/}" | dmenu -l 15 -c)
echo ":spawn -u $script" > "$QUTE_FIFO"

