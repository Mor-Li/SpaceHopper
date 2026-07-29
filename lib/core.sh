#!/bin/zsh
# SpaceHopper Core Library
# Provides core functionality for desktop switching

# SpaceHopper 项目根目录
# 用户可以设置环境变量 SPACEHOPPER_HOME 来覆盖默认路径
: ${SPACEHOPPER_HOME:="/Users/limo/Documents/GithubRepo/SpaceHopper"}

# 键码映射表
declare -A keycode_map=(
    [1]=18
    [2]=19
    [3]=20
    [4]=21
    [5]=23
    [6]=22
    [7]=26
    [8]=28
    [9]=25
    [0]=29
)

switch_to_target_desktop() {
    local target_desktop="$1"

    # 直接使用 yabai 查询当前空间（最快）
    local current_space=$(yabai -m query --spaces --space | jq -r ".index")

    if [ -z "$current_space" ]; then
        echo "Debug: Failed to get current space."
        return 1
    fi

    if [ "$current_space" -ne "$target_desktop" ]; then
        # 切换到目标桌面
        echo "Debug: Switching from space $current_space to space $target_desktop."

        # ✅ 关键优化：在离开当前桌面前，如果当前是 VSCode 桌面，先记录
        # 下面是三种显示器模式下 IDE 桌面编号的并集（单屏 5/6/7、双屏 10/11/12、三屏 11/12/13），
        # 只是一道省开销的粗筛：命中了才去 source tracker 多跑一次 yabai query。
        # 编号在不同模式下语义不同（比如单屏 10 是「其他」），但 vscode_tracker.sh 内部会再数一遍
        # 该桌面有没有 Code/Cursor 窗口，没有就不记录，所以粗筛放宽只会白跑查询，不会记错桌面。
        if [[ "$current_space" =~ ^(5|6|7|10|11|12|13)$ ]]; then
            source "$SPACEHOPPER_HOME/lib/vscode_tracker.sh" 2>/dev/null
        fi

        echo "$current_space" > /tmp/last_space
        yabai -m space --focus "$target_desktop" 2>/dev/null
    else
        # 切换回之前的桌面
        if [ -f /tmp/last_space ]; then
            local previous_space=$(cat /tmp/last_space)
            echo "Debug: Switching back to space $previous_space."
            yabai -m space --focus "$previous_space" 2>/dev/null
        else
            echo "Debug: No previous space recorded."
        fi
    fi
}
