#!/usr/bin/env bash
[ "$BLOCK_BUTTON" -eq 1 ] && i3-scratchpad-dmenu.py

i3-msg -t get_tree | jq -Mcr '.. | .nodes? // empty | .[] |
    select(.name == "__i3_scratch") |
    (.floating_nodes + .nodes) | .. |
    "[\(.name? // empty)]"' | tr \\n ' ' | sed 's/^/ /'
echo
exit 0
