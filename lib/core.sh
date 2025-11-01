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
        if [[ "$current_space" =~ ^(5|6|7|11|12|13)$ ]]; then
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
