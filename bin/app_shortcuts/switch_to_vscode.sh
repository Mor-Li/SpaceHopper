#!/bin/zsh

# SpaceHopper 项目根目录
: ${SPACEHOPPER_HOME:="/Users/limo/Documents/GithubRepo/SpaceHopper"}


# 导入 keycode_map
source $SPACEHOPPER_HOME/lib/core.sh

# 获取当前显示器的数量
num_displays=$(yabai -m query --displays | jq '. | length')

# 定义记录文件的位置：按显示器数量分开存，详见 lib/vscode_tracker.sh 的说明
# （同一个数字在单屏/双屏下是不同桌面，共用一个文件会导致插拔外接屏后跳错）
last_vscode_desktop_file="/tmp/last_vscode_desktop_${num_displays}"

# 检查记录文件是否存在
if [ -f "$last_vscode_desktop_file" ]; then
    # 读取最后使用的 VS Code 桌面编号
    target_desktop=$(cat "$last_vscode_desktop_file")
    echo "准备跳转到最后使用的 VS Code 桌面：$target_desktop"
else
    # 如果记录文件不存在，使用默认的桌面编号
    echo "未找到最后使用的 VS Code 桌面记录，使用默认桌面编号"

    # 根据显示器数量定义默认的目标桌面编号
    if [ "$num_displays" -eq 1 ]; then
        target_desktop=5  # 单显示器：Local IDE，跟 yabai 规则里 Code/Cursor 的兜底 space=5 保持一致
    elif [ "$num_displays" -eq 2 ]; then
        target_desktop=10  # 双显示器：副屏大屏的 Local IDE，跟 dual 规则里 Code/Cursor 的兜底 space=10 保持一致
    elif [ "$num_displays" -eq 3 ]; then
        target_desktop=11  # 三显示器情况下的默认桌面
    else
        target_desktop=6  # 更多显示器情况下的默认桌面
    fi
fi

# 调用提取的函数来处理桌面切换逻辑
switch_to_target_desktop "$target_desktop"  # sleep_duration默认为0.2秒
