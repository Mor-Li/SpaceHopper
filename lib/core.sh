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
    # 每次跳桌面前，先检测当前是否在vscode，用来记录在最后的vscode的桌面的位置
    source "$SPACEHOPPER_HOME/lib/vscode_tracker.sh"

    local target_desktop="$1"
    local sleep_duration="${2:-0.001}"  # 默认睡眠时间为0.001秒
    local current_space=$(yabai -m query --spaces --space | jq -r ".index")
    # 等待指定时间
    sleep "$sleep_duration"

    if [ -n "$current_space" ]; then
        if [ "$current_space" -ne "$target_desktop" ]; then
            echo "Debug: Not on target space $target_desktop, saving current space and switching to space $target_desktop."
            echo $current_space > /tmp/last_space

            # 使用 yabai 原生命令切换桌面（更可靠）
            yabai -m space --focus "$target_desktop" 2>/dev/null

            echo "Debug: Switched to space $target_desktop."
        else
            if [ -f /tmp/last_space ]; then
                previous_space=$(cat /tmp/last_space)
                echo "Debug: Previous space recorded as $previous_space."

                # 使用 yabai 原生命令切换桌面（更可靠）
                yabai -m space --focus "$previous_space" 2>/dev/null
            else
                echo "Debug: No previous space recorded."
            fi
        fi
    else
        echo "Debug: Failed to get current space."
    fi
}

     