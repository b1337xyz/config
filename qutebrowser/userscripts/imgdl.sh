#!/bin/sh
dest=$(find ~/Pictures -type d | dmenu -l 10 -c -i -n)
[ -d "$dest" ] && printf 'hint images run download --dest "%s" {hint-url}\n' "$dest" > "$QUTE_FIFO"
exit 0
