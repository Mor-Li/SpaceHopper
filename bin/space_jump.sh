#!/bin/zsh
# Alt+Space -> 主切换器：在当前桌面与桌面 2 之间来回 toggle

: ${SPACEHOPPER_HOME:=${0:A:h:h}}
source "$SPACEHOPPER_HOME/lib/core.sh"

switch_to_target_desktop 2
