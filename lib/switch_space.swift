// switch_space.swift
// 在 HID 层用 CGEvent 模拟按下「Ctrl+数字」来触发 macOS 自带的「切换到桌面 N」。
// 比 osascript(System Events)更接近真实键盘，切空间更不容易被系统忽略。
// 需要：调用进程具备「辅助功能」权限；系统已启用「切换到桌面 N」快捷键。
//
// 用法: switch-space <桌面号 1-9>

import CoreGraphics
import Foundation

let n = CommandLine.arguments.count > 1 ? (Int(CommandLine.arguments[1]) ?? 0) : 0

let keymap: [Int: CGKeyCode] = [1: 18, 2: 19, 3: 20, 4: 21, 5: 23, 6: 22, 7: 26, 8: 28, 9: 25, 0: 29]

guard let kc = keymap[n] else {
    FileHandle.standardError.write("switch-space: 仅支持桌面号 1-9，收到 \(n)\n".data(using: .utf8)!)
    exit(1)
}

let src = CGEventSource(stateID: .hidSystemState)

if let down = CGEvent(keyboardEventSource: src, virtualKey: kc, keyDown: true) {
    down.flags = .maskControl
    down.post(tap: .cghidEventTap)
}
usleep(15000)
if let up = CGEvent(keyboardEventSource: src, virtualKey: kc, keyDown: false) {
    up.flags = .maskControl
    up.post(tap: .cghidEventTap)
}
