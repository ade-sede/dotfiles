#!/bin/bash

# Get the list of outputs and windows
outputs=$(swaymsg -t get_outputs | jq -r '.[].name')
windows=$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .name' | grep -v "^$")

# Combine both lists with labels
(
    echo "$outputs" | sed 's/^/Screen: /'
    echo "$windows" | sed 's/^/Window: /'
) | wofi --show dmenu -p "Select what to share" | cut -d' ' -f2-
