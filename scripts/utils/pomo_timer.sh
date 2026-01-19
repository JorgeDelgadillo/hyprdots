#!/bin/bash

function pomo() {
    local work_min=${1:-25}
    local break_min=${2:-5}
    local task_msg="${3:-Work Session}"

    local green="\e[32m"
    local white="\e[97m"
    local purple="\e[38;5;99m"
    local reset="\e[0m"
    local dim="\e[2m"

    tput civis
    trap "tput cnorm; exit" SIGINT

    while true; do
        _run_pomo_timer "$work_min" "$task_msg" "pom"
        notify-send -u critical -t 5000 "Work Finished" "Time for a ${break_min}m break!"

        _run_pomo_timer "$break_min" "Resting" "break"
        notify-send -u normal -t 5000 "Break Finished" "Back to: $task_msg"
    done
}

function _run_pomo_timer() {
    local duration_min=$1
    local label=$2
    local type_tag=$3

    local total_sec=$((duration_min * 60))
    local start_time=$(date +%s)
    local end_time=$((start_time + total_sec))
    local fmt_end=$(date -d "@$end_time" +"%I:%M%p")

    local green="\e[32m"
    local white="\e[97m"
    local purple="\e[38;5;99m"
    local reset="\e[0m"
    local dark_blue="\e[38;5;12m"
    local dim="\e[2m"

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

        # Redraw UI without flickering
        clear
        echo -e "${green}$(date +"%H:%M:%S") → ${type_tag}${reset}"
        echo -e "${white}${fmt_end} - ${rem_m}m${rem_s}s${reset}"

        local bar_str="${dark_blue}$(printf '█%.0s' $(seq 1 $filled))"
        local space_str="${dim}$(printf '▒%.0s' $(seq 1 $empty))"
        echo -e "${bar_str}${space_str}${reset}   ${white}${percent}%${reset}"
        echo -e "\n${dim}Task: ${label}${reset}"

        sleep 1
    done
}
