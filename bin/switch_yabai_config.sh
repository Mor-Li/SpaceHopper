#!/bin/zsh
# 按显示器数量把对应的 yabairc 拷到 ~/.yabairc 并重启 yabai。
#
# 两种用法：
#   1. 自动：三份 yabairc 都挂了 display_added / display_removed 信号，插拔显示器时 yabai 自己调本脚本
#   2. 手动：终端里敲 switch_yabai_config，带 --force 调本脚本，配置没变也照样重启
#
# 自动模式下 ~/.yabairc 已经是对的配置就什么都不做，所以显示器休眠唤醒这类抖动不会反复重启 yabai。
# 日志：/tmp/spacehopper_switch_config.log

: ${SPACEHOPPER_HOME:="/Users/limo/Documents/GithubRepo/SpaceHopper"}

# yabai 信号里跑的命令拿不到 shell 的 PATH，homebrew 的命令写全路径
YABAI=/opt/homebrew/bin/yabai
JQ=/opt/homebrew/bin/jq
LOG=/tmp/spacehopper_switch_config.log
LOCK=/tmp/spacehopper_switch_config.lock

force=0
[[ "$1" == "--force" ]] && force=1

log() { echo "$(date '+%F %T') $*" | tee -a "$LOG"; }

# 插一次显示器 yabai 可能连发好几个事件，同一时间只让一个实例干活
if ! mkdir "$LOCK" 2>/dev/null; then
    # 锁超过 30 秒还在，说明上次中途被杀了，清掉重来
    if (( $(date +%s) - $(stat -f %m "$LOCK") > 30 )); then
        rmdir "$LOCK"; mkdir "$LOCK"
    else
        exit 0
    fi
fi
trap 'rmdir "$LOCK" 2>/dev/null' EXIT

# 刚插拔时 macOS 还在重排桌面，等它稳下来再数显示器
(( force )) || sleep 2

num_displays=$($YABAI -m query --displays | $JQ 'length')

case "$num_displays" in
    1) target="$SPACEHOPPER_HOME/configs/yabai/single_display.yabairc" ;;
    2) target="$SPACEHOPPER_HOME/configs/yabai/dual_display.yabairc" ;;
    3) target="$SPACEHOPPER_HOME/configs/yabai/triple_display.yabairc" ;;
    *) log "不支持的显示器数量: '$num_displays'，不动"; exit 1 ;;
esac

if (( ! force )) && cmp -s "$target" "$HOME/.yabairc"; then
    log "$num_displays 块屏，~/.yabairc 已经是 ${target:t}，不用切"
    exit 0
fi

log "$num_displays 块屏，切到 ${target:t} 并重启 yabai"
cp "$target" "$HOME/.yabairc"
rmdir "$LOCK" 2>/dev/null
# 重启会杀掉 yabai 连带本脚本，所以放在最后一步
$YABAI --restart-service
