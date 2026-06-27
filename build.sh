#!/bin/zsh
# 编译 SpaceHopper(lite/无 yabai 版)所需的两个 Swift helper。
# 需要 Xcode Command Line Tools（swiftc）。
set -e

ROOT="${0:A:h}"
cd "$ROOT"

echo "编译 current-space (查询当前桌面/显示器，SkyLight 只读)..."
swiftc -O lib/current_space.swift -o bin/current-space \
    -F /System/Library/PrivateFrameworks -framework SkyLight

echo "编译 switch-space (CGEvent 模拟 Ctrl+N 切桌面)..."
swiftc -O lib/switch_space.swift -o bin/switch-space

chmod +x bin/current-space bin/switch-space bin/space_jump.sh bin/app_shortcuts/*.sh

echo "✅ 完成：bin/current-space, bin/switch-space"
