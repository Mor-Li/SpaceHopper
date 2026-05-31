#!/bin/zsh

# SpaceHopper 项目根目录
: ${SPACEHOPPER_HOME:="/Users/limo/Documents/GithubRepo/SpaceHopper"}


# 导入 keycode_map
source $SPACEHOPPER_HOME/lib/core.sh

# 获取当前显示器的数量
num_displays=$(yabai -m query --displays | jq '. | length')

# 根据显示器数量定义 Termius 所在的目标桌面编号
if [ "$num_displays" -eq 1 ]; then
    target_desktop=4  # 单显示器：Termius 跟 PPT/PDF/Zotero 共用 Space 4
elif [ "$num_displays" -eq 2 ]; then
    target_desktop=8  # 双显示器：Local IDE space（dual 暂未给 Termius 设规则）
elif [ "$num_displays" -eq 3 ]; then
    target_desktop=1  # 三显示器：通讯 space（triple 暂未给 Termius 设规则）
else
    target_desktop=1
fi

# 调用提取的函数来处理桌面切换逻辑
switch_to_target_desktop "$target_desktop"  # sleep_duration默认为0.2秒