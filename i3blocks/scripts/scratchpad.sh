#!/usr/bin/env bash
test -n "$BLOCK_BUTTON" && i3-scratchpad-dmenu.py

i3-msg -t get_tree | jq -Mrc '.. | .nodes? // empty | .[] |
    select(.name == "__i3_scratch") |
    (.floating_nodes + .nodes) | .. |
    "[\(.name? // empty)]"' | tr \\n ' ' | sed 's/^/ /'
echo
exit 0
