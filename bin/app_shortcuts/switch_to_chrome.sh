#!/bin/zsh
# Ctrl+E -> 桌面 2：浏览器（如 Chrome）

: ${SPACEHOPPER_HOME:=${0:A:h:h:h}}
source "$SPACEHOPPER_HOME/lib/core.sh"

switch_to_target_desktop 2
