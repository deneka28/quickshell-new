#!/bin/bash

# Получаем ID текущего воркспейса
current_workspace=$(hyprctl -j activeworkspace | jq -r '.id')

# Фильтруем окна только текущего воркспейса
selected=$(hyprctl -j clients | jq -r --argjson ws "$current_workspace" \
    '.[] | select(.workspace.id == $ws) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp -r)

if [ -z "$selected" ]; then
    exit 1
fi

grim -g "$selected" - | wl-copy
