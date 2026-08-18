#!/bin/bash
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"

# Получаем координаты активного окна
coords=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')

echo "Coordinates: $coords" >&2

# Делаем скриншот
grim -g "$coords" - | wl-copy
