# Space 8 和 Space 9 互换记录

## 更改时间
2025-07-28

## 更改目的
为了方便将未来的 space 9、10、11 全部分配到第二个显示器上，需要将原来的 space 8 和 space 9 功能互换。

## 具体更改内容

### 原配置
- **Space 8**: 浏览器 & PDF Expert（包含飞书云文档）
- **Space 9**: Local IDE

### 更改后配置
- **Space 8**: Local IDE
- **Space 9**: 浏览器 & PDF Expert（包含飞书云文档）

## 修改的文件
- `.yabairc_dual`

## 具体修改内容

### 1. Space 布局配置更改
```bash
# 原配置
# Space 8------浏览器
yabai -m space 8 --layout stack

# Space 9------Local IDE
yabai -m space 9 --layout stack

# 更改后
# Space 8------Local IDE
yabai -m space 8 --layout stack

# Space 9------浏览器
yabai -m space 9 --layout stack
```

### 2. 应用规则更改
```bash
# 原配置
# Space 8------浏览器 & PDF Expert（包含飞书云文档）
yabai -m rule --add app="Google Chrome" space=8
yabai -m rule --add app="PDF Expert" space=8

# Space 9------Local IDE
yabai -m rule --add app='Code' title=".*" space=9
yabai -m rule --add app='Cursor' title=".*" space=9

# 更改后
# Space 8------Local IDE
yabai -m rule --add app='Code' title=".*" space=8
yabai -m rule --add app='Cursor' title=".*" space=8

# Space 9------浏览器 & PDF Expert（包含飞书云文档）
yabai -m rule --add app="Google Chrome" space=9
yabai -m rule --add app="PDF Expert" space=9
```

## 影响分析
- Local IDE (VSCode, Cursor) 现在会自动分配到 space 8
- 浏览器 (Google Chrome) 和 PDF Expert 现在会自动分配到 space 9
- 为后续将 space 9、10、11 分配到第二个显示器做好了准备

## 注意事项
- 更改后需要重新启动 yabai 或重新加载配置文件以使更改生效
- 已打开的应用程序需要手动移动到新的 space，或者重新启动应用程序以应用新规则