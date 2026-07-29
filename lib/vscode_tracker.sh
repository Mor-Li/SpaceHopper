#!/bin/zsh

# 定义记录文件的位置：按显示器数量分开存
# 同一个数字在不同模式下指的是完全不同的桌面（5 在单屏是本地 IDE，在双屏是邮件），
# 共用一个文件的话，插拔一次外接屏 Ctrl+V 就会跳到风马牛不相及的桌面
num_displays=$(yabai -m query --displays | jq '. | length')
last_vscode_desktop_file="/tmp/last_vscode_desktop_${num_displays}"

# 获取要记录的桌面编号
# core.sh 是在「离开当前桌面之前」source 本脚本的，那时它已经算好 current_space，直接复用省一次 query；
# 单独执行本脚本时则自己查一次
current_desktop=${current_space:-$(yabai -m query --spaces --space | jq '.index')}

# 数一下这个桌面里有几个 IDE 窗口（Code / Cursor）
# 只看「这个桌面有没有 IDE」，不看「当前聚焦的是不是 IDE」：Space 5 里还住着 Claude，
# 它经常抢焦点，按焦点判断会导致 Space 5 永远记不上，Ctrl+V 从而跳错桌面
ide_count=$(yabai -m query --windows --space "$current_desktop" | jq '[.[] | select(.app == "Code" or .app == "Cursor")] | length')

# 桌面里有 IDE，且不是 Space 1（通讯 space），才记录
if [ "$ide_count" -gt 0 ] && [ "$current_desktop" -ne 1 ]; then
    echo "$current_desktop" > "$last_vscode_desktop_file"
    echo "已记录最后使用的 IDE 桌面编号：$current_desktop（该桌面有 $ide_count 个 Code/Cursor 窗口）"
fi
