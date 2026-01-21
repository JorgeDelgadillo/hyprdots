#!/usr/bin/env bash

# This works in both Bash and Zsh
pomo() {
    local work_min=${1:-25}
    local break_min=${2:-5}
    local task_msg="${3:-Work Session}"

    tput civis
    trap "tput cnorm; return" SIGINT 2>/dev/null || trap "tput cnorm; exit" SIGINT

    while true; do
        _run_pomo_timer "$work_min" "$task_msg" "pom"
        notify-send -u critical -t 5000 "Work Finished" "Time for a ${break_min}m break!"

        _run_pomo_timer "$break_min" "Resting" "break"
        notify-send -u normal -t 5000 "Break Finished" "Back to: $task_msg"
    done
}

_run_pomo_timer() {
    local duration_min=$1
    local label=$2
    local type_tag=$3

    local total_sec=$((duration_min * 60))
    local start_time=$(date +%s)
    local end_time=$((start_time + total_sec))
    # Note: 'date -d' is GNU specific (Linux). For macOS/BSD, use: date -r $end_time
    local fmt_end=$(date -d "@$end_time" +"%I:%M%p" 2>/dev/null || date -r "$end_time" +"%I:%M%p")

    local green="\033[32m"
    local white="\033[97m"
    local purple="\033[38;5;99m"
    local reset="\033[0m"
    local dark_blue="\033[38;5;12m"
    local dim="\033[2m"

    while true; do
        local now=$(date +%s)
        local elapsed=$((now - start_time))
        local remaining=$((total_sec - elapsed))

        if [ "$remaining" -le 0 ]; then break; fi

        local bar_width=25
        local filled=$(( (elapsed * bar_width) / total_sec ))
        local empty=$(( bar_width - filled ))
        local percent=$(( (elapsed * 100) / total_sec ))

        local rem_m=$((remaining / 60))
        local rem_s=$((remaining % 60))

        # Redraw UI
        clear
        printf "${purple}%s → %s${reset}\n" "$(date +"%H:%M:%S")" "$type_tag"
        printf "${white}%s - %sm%ss${reset}\n" "$fmt_end" "$rem_m" "$rem_s"

        # Generate progress bar compatibly
        local bar_str=""
        local space_str=""
        for i in $(seq 1 $filled 2>/dev/null || echo {1..$filled}); do [ $filled -gt 0 ] && bar_str="${bar_str}█"; done
        for i in $(seq 1 $empty 2>/dev/null || echo {1..$empty}); do [ $empty -gt 0 ] && space_str="${space_str}▒"; done

        printf "${dark_blue}%s${dim}%s${reset}   ${white}%d%%${reset}\n" "$bar_str" "$space_str" "$percent"
        printf "\n${dim}Task: %s${reset}\n" "$label"

        sleep 1
    done
}
