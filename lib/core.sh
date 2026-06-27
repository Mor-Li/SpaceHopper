#!/bin/zsh
# SpaceHopper Core Library —— 无 yabai 版（不需要关闭 SIP）
#
# 设计：
#   - 查询当前桌面：用 bin/current-space（SkyLight 只读，能感知三指滑动等任何切换）
#   - 切换桌面：模拟按下 macOS 自带的「切换到桌面 N」快捷键（默认 Ctrl+N）
#   - 状态跟踪 toggle：每次切换前现查真实当前桌面，所以手滑也不会脱节
#
# 前提（一次性，系统设置里点一下，均不需要关 SIP）：
#   1) 系统设置 → 键盘 → 键盘快捷键 → 调度中心：勾选「切换到桌面 1/2/3…」(保持默认 Ctrl+数字)
#   2) 给 skhd 开「辅助功能」权限（osascript 发按键需要）

# SpaceHopper 项目根目录
# 正常情况下由调用脚本（bin/*.sh）自动设置；这里仅作兜底。
: ${SPACEHOPPER_HOME:="$HOME/Documents/GithubRepo/SpaceHopper"}

# 切换前的延迟（秒）。来自项目作者的经验：触发键的修饰键若未松开，
# osascript 发的按键会失效（会把数字打进输入框）。留一点延迟规避。
: ${SPACEHOPPER_SWITCH_DELAY:=0.12}

HELPER="$SPACEHOPPER_HOME/bin/current-space"

# 数字 -> 键码 映射（用于模拟 Ctrl+数字）
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

# 查询当前活动桌面的全局序号（失败返回 -1）
get_current_space() {
    "$HELPER"
}

# 查询当前显示器数量
get_num_displays() {
    "$HELPER" displays
}

# 切换到桌面 N：用 CGEvent(HID 层) 模拟「Ctrl+N」触发系统自带的「切换到桌面 N」。
# 比 osascript/System Events 更接近真实键盘，切空间更不易被系统忽略。
focus_space() {
    local target="$1"
    if [ -z "${keycode_map[$target]}" ]; then
        echo "Debug: 桌面号 $target 没有对应的 Ctrl+数字 快捷键（只支持 1-9）。" >&2
        return 1
    fi
    # 规避修饰键未松开导致的失效
    sleep "$SPACEHOPPER_SWITCH_DELAY"
    "$SPACEHOPPER_HOME/bin/switch-space" "$target"
}

# 核心：跳转 + toggle 返回
#   - 当前不在目标桌面：记录当前桌面，跳到目标
#   - 当前已在目标桌面：跳回上次记录的桌面（toggle）
switch_to_target_desktop() {
    local target_desktop="$1"
    local current_space
    current_space=$(get_current_space)

    # 查询失败兜底：直接跳目标，不做 toggle
    if [ -z "$current_space" ] || [ "$current_space" -lt 1 ] 2>/dev/null; then
        echo "Debug: 查询当前桌面失败，直接跳转到 $target_desktop。" >&2
        focus_space "$target_desktop"
        return 0
    fi

    if [ "$current_space" -ne "$target_desktop" ]; then
        echo "Debug: 从桌面 $current_space 切换到桌面 $target_desktop。" >&2
        echo "$current_space" > /tmp/last_space
        focus_space "$target_desktop"
    else
        if [ -f /tmp/last_space ]; then
            local previous_space
            previous_space=$(cat /tmp/last_space)
            echo "Debug: 已在桌面 $target_desktop，toggle 回桌面 $previous_space。" >&2
            focus_space "$previous_space"
        else
            echo "Debug: 没有记录上一个桌面，无法 toggle。" >&2
        fi
    fi
}
