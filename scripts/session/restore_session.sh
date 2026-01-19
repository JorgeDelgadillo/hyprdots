#!/usr/bin/env bash
# Hyprland dynamic session restorer
# Restores all windows with workspace, position, and size
# Works with Chrome PWAs and normal apps

SESSION_FILE="$HOME/.config/hypr/saved-session/session.json"
[ -f "$SESSION_FILE" ] || { echo "No session file found."; exit 0; }

launch_app() {
    local class="$1"

    case "$class" in
        # --- Browsers & PWAs ---
        google-chrome|chrome-*|Chromium|chromium)
            google-chrome & ;;
        
        # --- Editors ---
        code|code-url-handler)
            code & ;;
        
        # --- Terminals ---
        kitty|Alacritty|wezterm|org.wezfurlong.wezterm)
            alacritty & ;;
        
        # --- Chat / Communication apps ---
        discord|Slack|TelegramDesktop)
            $class & ;;
        
        # --- Default fallback ---
        *)
            setsid "$class" &>/dev/null &
            ;;
    esac
}

# Track launched apps to avoid duplicates
declare -A launched

# Read each window entry from saved session
jq -c '.[]' "$SESSION_FILE" | while read -r item; do
    class=$(echo "$item" | jq -r '.class')
    title=$(echo "$item" | jq -r '.title')
    ws=$(echo "$item" | jq -r '.workspace')
    x=$(echo "$item" | jq -r '.x')
    y=$(echo "$item" | jq -r '.y')
    w=$(echo "$item" | jq -r '.w')
    h=$(echo "$item" | jq -r '.h')

    # Skip duplicates (e.g., multiple Chrome windows)
    if [[ -n "${launched[$class]}" ]]; then
        echo "Skipping duplicate: $class"
        continue
    fi
    launched[$class]=1

    echo "Restoring $class on workspace $ws..."
    launch_app "$class"

    # Wait up to 20s for the window to appear
    addr=""
    for i in {1..40}; do
        addr=$(hyprctl clients -j | jq -r \
            --arg class "$class" \
            '.[] | select(.class==$class) | .address' | head -n 1)
        [ -n "$addr" ] && break
        sleep 0.5
    done

    if [ -n "$addr" ]; then
        hyprctl dispatch focuswindow address:"$addr"
        hyprctl dispatch movetoworkspace "$ws"
        hyprctl dispatch moveactive exact "$x" "$y"
        hyprctl dispatch resizeactive exact "$w" "$h"
        echo "  -> Restored $class to workspace $ws"
    else
        echo "  ⚠️  Could not find $class window"
    fi
done

notify-send "🪄 Hyprland session restored" "Windows reloaded from last session."

