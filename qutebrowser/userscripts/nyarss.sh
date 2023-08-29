#!/usr/bin/env bash
if [[ "$QUTE_URL" =~ /user/ ]];then
    echo -n "$QUTE_URL" | sed 's/?//; s/[cf]=[^&]*//g; s/&&/\&/g; s/user\//?page=rss\&u=/;'
else
    echo -n "$QUTE_URL" | sed 's/[cf]=[^&]*//g; s/&&/\&/g; s/$/\&page=rss/'
fi | xclip -sel c
clip=$(xclip -sel clip -o)
notify-send "Copied to the clipboard" "$clip"
echo "open -t $clip" >> "$QUTE_FIFO"
