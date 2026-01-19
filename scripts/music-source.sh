#!/bin/bash

# Script to detect music source and output JSON for waybar
# Supports Spotify, YouTube (browser), Twitch (browser), and other sources

# Get the currently playing media info using playerctl
if ! command -v playerctl &> /dev/null; then
    echo '{"text": "No playerctl", "class": "unknown"}'
    exit 1
fi

# Get all active players
players=$(playerctl -l 2>/dev/null)
if [ -z "$players" ]; then
    echo '{"text": "No media", "class": "unknown"}'
    exit 0
fi

# Get the currently active player
active_player=$(playerctl status -f "{{playerName}}" 2>/dev/null | head -1)
if [ -z "$active_player" ]; then
    echo '{"text": "No active player", "class": "unknown"}'
    exit 0
fi

# Get media info
artist=$(playerctl metadata artist 2>/dev/null | head -c 20)
title=$(playerctl metadata title 2>/dev/null | head -c 20)
status=$(playerctl status 2>/dev/null)

# Default values
if [ -z "$artist" ]; then
    artist="Unknown"
fi
if [ -z "$title" ]; then
    title="Unknown"
fi

# Determine the source and set class accordingly
css_class="unknown"
source_icon="🎵"

case "$active_player" in
    *spotify*)
        css_class="spotify"
        source_icon="🎵"
        ;;
    *firefox*|*chrome*|*chromium*|*brave*|*edge*)
        # For browsers, we need to check the title or URL for YouTube or Twitch
        url_title=$(playerctl metadata title 2>/dev/null)
        url_metadata=$(playerctl metadata xesam:url 2>/dev/null)
        
        # Check URL first, then title
        if [[ "$url_metadata" == *"youtube.com"* ]] || [[ "$url_metadata" == *"youtu.be"* ]] || [[ "$url_title" == *"YouTube"* ]] || [[ "$url_title" == *"youtube"* ]]; then
            css_class="youtube"
            source_icon="📺"
        elif [[ "$url_metadata" == *"twitch.tv"* ]] || [[ "$url_title" == *"Twitch"* ]] || [[ "$url_title" == *"twitch"* ]]; then
            css_class="twitch"
            source_icon="🎮"
        else
            css_class="browser"
            source_icon="🌐"
        fi
        ;;
    *)
        css_class="other"
        source_icon="🎵"
        ;;
esac

# Set status icon
if [ "$status" = "Playing" ]; then
    status_icon="⏸"
else
    status_icon="▶"
fi

# Truncate text if too long
if [ ${#artist} -gt 15 ]; then
    artist="${artist:0:12}..."
fi
if [ ${#title} -gt 20 ]; then
    title="${title:0:17}..."
fi

# Output JSON for waybar
echo "{\"text\": \"$source_icon $artist - $title $status_icon\", \"class\": \"$css_class\", \"tooltip\": \"Source: $active_player\\nArtist: $(playerctl metadata artist 2>/dev/null)\\nTitle: $(playerctl metadata title 2>/dev/null)\\nStatus: $status\"}"