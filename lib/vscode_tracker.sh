#!/bin/zsh

# 定义记录文件的位置
last_vscode_desktop_file="/tmp/last_vscode_desktop"

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
