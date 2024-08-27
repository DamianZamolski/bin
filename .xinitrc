#!/bin/sh

declare -A power_modes=(["low-power"]="L" ["balanced"]="M" ["performance"]="H")

while true; do
  battery_capacity=$(cat /sys/class/power_supply/BAT0/capacity)
  battery_status=$(cat /sys/class/power_supply/BAT0/status)

  if (( $battery_capacity >= 95 )); then
    battery_icon="󰁹"
  elif (( $battery_capacity >= 85 )); then
    battery_icon="󰂂"
  elif (( $battery_capacity >= 75 )); then
    battery_icon="󰂁"
  elif (( $battery_capacity >= 65 )); then
    battery_icon="󰂀"
  elif (( $battery_capacity >= 55 )); then
    battery_icon="󰁿"
  elif (( $battery_capacity >= 45 )); then
    battery_icon="󰁾"
  elif (( $battery_capacity >= 35 )); then
    battery_icon="󰁽"
  elif (( $battery_capacity >= 25 )); then
    battery_icon="󰁼"
  elif (( $battery_capacity >= 15 )); then
    battery_icon="󰁻"
  elif (( $battery_capacity >= 5 )); then
    battery_icon="󰁺"
  else
    battery_icon="󰂎"
  fi

  if [ $battery_status == "Charging" ]; then
    battery_charging_icon="󱐋"
  else
    battery_charging_icon=""
  fi
  
  battery="$battery_icon$battery_charging_icon $battery_capacity% (${power_modes[$(cat /sys/firmware/acpi/platform_profile)]})"
  cpu=$(mpstat | awk '/all/ {print " "$13"%"}')
  date_time=$(date +'%Y-%m-%d %H:%M:%S')
  ram=$(free -h | awk '/Mem/ {print " "$7}')
  volume="󰕾 $(wpctl get-volume @DEFAULT_SINK@ | awk '{ print $2 * 100"%" }')"
  xsetroot -name "$volume   $cpu   $ram   $battery   $date_time"
  sleep 1s
done &

feh --bg-scale ~/dz/images/wallpaper.jpg
setxkbmap pl -option caps:escape
exec dwm
