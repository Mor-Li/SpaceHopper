# Yabai Float 模式 z-order 卡死 Bug 记录

## 问题发现时间
2026-04-04

## 问题描述
在单屏模式下，Space 2（ChatGPT space）使用 `float` 布局时，窗口的 z-order（前后层级）会"卡住"：
- ChatGPT 窗口始终遮挡 Safari（Gemini）窗口
- 鼠标点击被遮挡的窗口无法将其切换到前面
- 但键盘焦点(focus)可以正常切换，只是视觉层级不变

同一配置下 Space 1（通讯软件）的 float 布局没有此问题，微信和飞书可以正常点击切换前后。

## 排查过程

### 1. 排除 yabai 属性差异
对比 Space 1 和 Space 2 的窗口属性（layer、sub-layer、level、sub-level、is-floating 等），**完全一致**，无任何差异。

### 2. 排除 ChatGPT App 置顶功能
通过 AppleScript 遍历了 ChatGPT 所有菜单项，确认没有"Always on Top"/"Keep on Top"等置顶功能。

### 3. 排除 macOS 窗口层级差异
通过 `CGWindowListCopyWindowInfo` 查询 macOS 窗口服务器，ChatGPT 和 Safari 主窗口的 `kCGWindowLayer` 均为 0，无差异。

### 4. 确认 focus 与 z-order 分离
通过 macOS 窗口服务器确认：
- Safari 可以获得键盘焦点（`has-focus: true`）
- 但 ChatGPT 的 z-order 索引始终更小（更靠前），视觉上始终遮挡 Safari

### 5. yabai 命令测试
- `yabai -m window --raise` → **无效**，z-order 不变
- `yabai -m window --sub-layer above/below` → **无效**，命令成功但属性未改变
- `yabai -m window --swap` → **失败**，float 模式下窗口 "not managed"
- `osascript -e 'tell application "Safari" to activate'` → **有效**，但会导致反转问题（ChatGPT 被卡在后面）

### 6. 找到临时修复方法
将 Space 2 layout 切换一轮（`float` → `bsp` → `float`）后，z-order 恢复正常，可以自由点击切换窗口。

## 根本原因
Yabai 的 scripting addition (`sudo yabai --load-sa`) 接管了 macOS 窗口管理后，float 模式下窗口的 z-order 有时会进入"卡死"状态。具体表现为：
- 点击窗口只改变键盘焦点，不改变视觉层级
- yabai 的 `--raise` 和 `--sub-layer` 命令在此状态下也无效
- 切换 layout 可以重置此状态

这是 yabai v7.1.16 在 float 模式下的一个已知行为。

## 修复方案
将 `single_display.yabairc` 中 Space 2 的布局从 `float` 改为 `stack`，与 `dual_display.yabairc` 保持一致。Stack 模式下 yabai 主动管理窗口堆叠和切换，不会出现 z-order 卡死问题。

## 修改的文件
- `configs/yabai/single_display.yabairc`：Space 2 layout `float` → `stack`

## 临时修复方法（如果其他 float space 遇到同样问题）
手动执行 layout toggle 重置 z-order：
```bash
yabai -m space <N> --layout bsp && sleep 0.3 && yabai -m space <N> --layout float
```
