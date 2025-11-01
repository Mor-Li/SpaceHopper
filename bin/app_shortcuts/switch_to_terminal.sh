#!/bin/zsh

# SpaceHopper 项目根目录
: ${SPACEHOPPER_HOME:="/Users/limo/Documents/GithubRepo/SpaceHopper"}


# 导入 keycode_map
source $SPACEHOPPER_HOME/lib/core.sh

# 获取当前显示器的数量
num_displays=$(yabai -m query --displays | jq '. | length')

# 根据显示器数量定义目标桌面编号 - Terminal现在放在Space 1
if [ "$num_displays" -eq 1 ]; then
    target_desktop=5  # 针对单显示器的设定，通讯space
elif [ "$num_displays" -eq 2 ]; then
    target_desktop=8  # 针对双显示器的设定，通讯space
elif [ "$num_displays" -eq 3 ]; then
    target_desktop=1  # 针对三显示器的设定，通讯space
else
    target_desktop=1  # 针对更多显示器的设定，通讯space
fi

# 调用提取的函数来处理桌面切换逻辑
switch_to_target_desktop "$target_desktop"  # sleep_duration默认为0.2秒