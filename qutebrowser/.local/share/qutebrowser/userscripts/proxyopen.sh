#!/bin/sh
echo "open -t https://www.proxysite.com" >> "$QUTE_FIFO"
sleep 1
echo "hint inputs --first" >> "$QUTE_FIFO" 
sleep 1
echo "fake-key $QUTE_URL<Return>" >> "$QUTE_FIFO" 
