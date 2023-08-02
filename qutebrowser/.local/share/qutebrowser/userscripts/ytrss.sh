#!/bin/sh
url=$(curl -s "$QUTE_URL" | grep -oP 'https://www.youtube.com/feeds/videos.xml.channel_id=[^"]*' | sort -u)
printf '%s' "$url" | xclip -sel clip
notify-send "RSS feed URL copied" "$url"
