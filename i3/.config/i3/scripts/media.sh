#!/bin/bash

# Handle clicks from i3blocks
case $BLOCK_BUTTON in
    1)  # Left click
        # Logic: If anything is playing, pause EVERYTHING.
        # If nothing is playing, start the most recent one via daemon.
        if playerctl --all-players status 2>/dev/null | grep -q "Playing"; then
            playerctl --all-players pause
        else
            playerctl -p playerctld play
        fi
        ;;
    2) playerctl -p playerctld previous ;; #Middle click
    3) playerctl -p playerctld next ;; # Right click
esac

# Get status and metadata (Prioritize Spotify)
PLAYER="playerctld"
STATUS=$(playerctl -p playerctld status 2>/dev/null)

# Fallback to browser if Spotify isn't running
# if [ -z "$STATUS" ]; then
#     PLAYER="firefox,chromium,brave"
#     STATUS=$(playerctl -p $PLAYER status 2>/dev/null)
# fi

if [ "$STATUS" = "Playing" ]; then
    INFO=$(playerctl -p $PLAYER metadata --format "{{ artist }} - {{ title }}")
    echo " ${INFO:0:80}" # Pause icon + truncated text
elif [ "$STATUS" = "Paused" ]; then
    INFO=$(playerctl -p $PLAYER metadata --format "{{ artist }} - {{ title }}")
    echo " ${INFO:0:80}" # Play icon + truncated text
else
    echo "" # Hide if nothing is playing
fi
