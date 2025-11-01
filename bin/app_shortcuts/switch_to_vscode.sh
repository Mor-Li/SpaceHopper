#!/bin/zsh

# SpaceHopper 项目根目录
: ${SPACEHOPPER_HOME:="/Users/limo/Documents/GithubRepo/SpaceHopper"}


# 导入 keycode_map
source $SPACEHOPPER_HOME/lib/core.sh

# 定义记录文件的位置
last_vscode_desktop_file="/tmp/last_vscode_desktop"

# 检查记录文件是否存在
if [ -f "$last_vscode_desktop_file" ]; then
    # 读取最后使用的 VS Code 桌面编号
    target_desktop=$(cat "$last_vscode_desktop_file")
    echo "准备跳转到最后使用的 VS Code 桌面：$target_desktop"
else
    # 如果记录文件不存在，使用默认的桌面编号
    echo "未找到最后使用的 VS Code 桌面记录，使用默认桌面编号"
    
    # 获取当前显示器的数量
    num_displays=$(yabai -m query --displays | jq '. | length')

    # 根据显示器数量定义默认的目标桌面编号
    if [ "$num_displays" -eq 1 ]; then
        target_desktop=6  # 单显示器情况下的默认桌面
    elif [ "$num_displays" -eq 2 ]; then
        target_desktop=8  # 双显示器情况下的默认桌面（Local IDE）
    elif [ "$num_displays" -eq 3 ]; then
        target_desktop=11  # 三显示器情况下的默认桌面
    else
        target_desktop=6  # 更多显示器情况下的默认桌面
    fi
fi

# 调用提取的函数来处理桌面切换逻辑
switch_to_target_desktop "$target_desktop"  # sleep_duration默认为0.2秒
