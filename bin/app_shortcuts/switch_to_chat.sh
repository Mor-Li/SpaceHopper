#!/bin/zsh
# Ctrl+K -> 桌面 1：聊天（如飞书）

# 自动定位仓库根目录（可用环境变量 SPACEHOPPER_HOME 覆盖）
: ${SPACEHOPPER_HOME:=${0:A:h:h:h}}
source "$SPACEHOPPER_HOME/lib/core.sh"

switch_to_target_desktop 1
