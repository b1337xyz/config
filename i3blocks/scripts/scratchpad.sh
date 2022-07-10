#!/usr/bin/env bash

i3-msg -t get_tree | jq -Mrc '.. | .nodes? // empty | .[] |
    select(.name == "__i3_scratch") |
    (.floating_nodes + .nodes) | .. |
    "[\(.name? // empty)]"' | tr \\n ' ' | sed 's/^/ /'
echo
exit 0
