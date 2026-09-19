#!/bin/bash
# Get the title of the Discord window using hyprctl
title=$(hyprctl clients -j | jq -r '.[] | select(.class == "vesktop") | .title')

# Extract the number inside the parentheses
count=$(echo "$title" | grep -oP '\(\d+\)' | tr -d '()')

if [ -z "$count" ]; then
    # No notifications
    echo "{\"text\": \" \", \"class\": \"none\"}"
else
    # Notifications found
    echo "{\"text\": \" <b>$count</b>\", \"class\": \"unread\"}"
fi
