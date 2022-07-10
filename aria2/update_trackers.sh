#!/bin/sh

conf=~/.config/aria2/aria2.conf
url=https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt

cp -v "$conf" "${conf}.copy"
curl -s "$url" | tee ~/.cache/trackers_best.txt | awk '
/[a-z]/{ s = s","$0 }
END {
    sub(/^,/, "", s)
    sub(/\//, "\\\\/", s)
    printf("bt-tracker=%s\n", s)
}' | xargs -rI{} sed -i 's/^bt-tracker=.*/{}/' "$conf"
