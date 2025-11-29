#!/bin/bash

# Get CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
cpu_usage_int=$(printf "%.0f" "$cpu_usage")

# Get RAM usage
ram_usage=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')

# Get temperature (try multiple sources)
temp=""
if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
    temp=$(cat /sys/class/thermal/thermal_zone0/temp)
    temp=$((temp / 1000))
elif command -v sensors &> /dev/null; then
    temp=$(sensors | grep -i 'Package id 0:\|Tdie:\|temp1:' | head -n1 | awk '{print $3}' | sed 's/+//;s/°C//' | cut -d'.' -f1)
fi

# Build output
if [ -n "$temp" ]; then
    text="🖥 ${cpu_usage_int}% 🧠 ${ram_usage}% 🌡 ${temp}°C"
    tooltip="CPU: ${cpu_usage_int}%\nRAM: ${ram_usage}%\nTemp: ${temp}°C"
else
    text="🖥 ${cpu_usage_int}% 🧠 ${ram_usage}%"
    tooltip="CPU: ${cpu_usage_int}%\nRAM: ${ram_usage}%"
fi

# Determine class based on usage
class="normal"
if [ "$cpu_usage_int" -gt 80 ] || [ "$ram_usage" -gt 80 ]; then
    class="high"
elif [ "$cpu_usage_int" -gt 60 ] || [ "$ram_usage" -gt 60 ]; then
    class="warning"
fi

# Output JSON for Waybar
echo "{\"text\":\"$text\",\"tooltip\":\"$tooltip\",\"class\":\"$class\"}"
