#!/usr/bin/env bash
capacity=$(cat /sys/class/power_supply/BAT?/capacity)
_status=$(cat /sys/class/power_supply/BAT?/status)
charging_color="#80F8E5"
full_color="#FFFFFF"

[ "$BLOCK_BUTTON" -eq 1 ] && { echo "$(acpi | cut -d':' -f2-) " ; exit ; }

if (( capacity > 0 && capacity < 20  ));then
    squares="■"
elif (( capacity >= 20 && capacity < 40 )); then
    squares="■■"
elif (( capacity >= 40 && capacity < 60 )); then
    squares="■■■"
elif (( capacity >= 60 && capacity < 80 )); then
    squares="■■■■"
elif (( capacity >= 80 )); then
    squares="■■■■■"
fi

case "${_status}" in
    "Charging")
        color="$charging_color"
    ;;
    "Full")
        color="$full_color"
    ;;
    "Discharging"|"Unknown")
        if (( capacity >= 0 && capacity < 10 )); then
            color="#FF0027"
        elif (( capacity >= 10 && capacity < 20 )); then
            color="#FF3B05"
        elif (( capacity >= 20 && capacity < 30 )); then
            color="#FFB923"
        elif (( capacity >= 30 && capacity < 40 )); then
            color="#FFD000"
        elif (( capacity >= 40 && capacity < 60 )); then
            color="#E4FF00"
        elif (( capacity >= 60 && capacity < 70 )); then
            color="#ADFF00"
        elif (( capacity >= 70 && capacity < 80 )); then
            color="#6DF000"
        elif (( capacity >= 80 )); then
            color="#10FA00"
        fi
    ;;
esac

echo "<span foreground=\"$color\">$capacity% $squares</span>"
