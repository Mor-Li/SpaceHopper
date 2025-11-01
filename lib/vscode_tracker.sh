#!/bin/zsh

# 定义记录文件的位置
last_vscode_desktop_file="/tmp/last_vscode_desktop"

# 获取当前活动窗口的信息
current_window=$(yabai -m query --windows --window)

# 获取当前活动窗口的应用程序名称
current_app=$(echo "$current_window" | jq -r '.app')

# 获取当前活动窗口所在的桌面编号
current_desktop=$(echo "$current_window" | jq '.space')
# 如果当前窗口是 VS Code 或者 Cursor，且当前桌面不是1（通讯space），则记录桌面编号
if ([ "$current_app" = "Code" ] || [ "$current_app" = "Cursor" ]) && [ "$current_desktop" -ne 1 ]; then
    echo "$current_desktop" > "$last_vscode_desktop_file"
    echo "已记录最后使用的应用程序 ($current_app) 的桌面编号：$current_desktop"
fi