#!/bin/zsh
# Ctrl+V -> 桌面 3：编辑器（如 Cursor / VSCode）

: ${SPACEHOPPER_HOME:=${0:A:h:h:h}}
source "$SPACEHOPPER_HOME/lib/core.sh"

switch_to_target_desktop 3
