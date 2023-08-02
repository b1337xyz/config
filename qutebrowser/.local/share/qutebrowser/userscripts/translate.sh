#!/usr/bin/env bash

if [ -z "$QUTE_SELECTED_TEXT" ];then
    url="https://translate.google.com/translate?sl=auto&tl=en&u=${QUTE_URL}"
else
    # query=$(echo -n "$QUTE_SELECTED_TEXT" | sed "s/[\"'<>]//g")
    query=$(python3 -c 'print(__import__("urllib.parse").parse.quote(__import__("sys").argv[1]).strip())' "$QUTE_SELECTED_TEXT")
    url="https://translate.google.com.br/?sl=auto&tl=en&text=${query}&op=translate"
fi
echo "open -t $url" >> "$QUTE_FIFO"
