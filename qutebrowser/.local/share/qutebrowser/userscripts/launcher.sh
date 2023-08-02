#!/bin/sh
script=$(find "${0%/*}" \! -name "${0##*/}" -printf '%f\n' | dmenu -l 10)
echo ":spawn -u $script" > "$QUTE_FIFO"
