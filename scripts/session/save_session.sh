#!/usr/bin/env bash

SAVE_DIR="$HOME/.config/hypr/saved-session"
SESSION_FILE="$SAVE_DIR/session.json"
mkdir -p "$SAVE_DIR"

# Get all user-visible windows (exclude hyprland internal ones)
hyprctl clients -j | jq '[.[] 
    | select(.mapped == true and .title != "" and .class != "")
    | {
        class: .class,
        title: .title,
        workspace: .workspace.id,
        x: .at[0],
        y: .at[1],
        w: .size[0],
        h: .size[1]
    }
]' > "$SESSION_FILE"

notify-send "💾 Hyprland session saved" "Saved $(jq length "$SESSION_FILE") windows."

