#!/bin/sh
echo "open -t https://www.proxysite.com" >> "$QUTE_FIFO"
sleep .5
echo "hint inputs --first" >> "$QUTE_FIFO" 
sleep .5
echo "fake-key $QUTE_URL<Return>" >> "$QUTE_FIFO" 
