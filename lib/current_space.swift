// current_space.swift
// 只读查询桌面/显示器信息，使用 SkyLight 私有框架。
// 不需要关闭 SIP，不需要 scripting addition（纯只读，不修改空间）。
//
// 用法:
//   current-space            -> 打印当前活动桌面的全局序号(1-based，跨显示器顺序计数，仅计普通桌面)
//   current-space displays   -> 打印当前连接的显示器数量
// 查不到当前桌面时打印 -1。

import Foundation

typealias CGSConnectionID = UInt32

@_silgen_name("SLSMainConnectionID")
func SLSMainConnectionID() -> CGSConnectionID

@_silgen_name("SLSCopyManagedDisplaySpaces")
func SLSCopyManagedDisplaySpaces(_ cid: CGSConnectionID) -> CFArray

@_silgen_name("SLSGetActiveSpace")
func SLSGetActiveSpace(_ cid: CGSConnectionID) -> UInt64

let cid = SLSMainConnectionID()
let mode = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "space"

guard let displays = SLSCopyManagedDisplaySpaces(cid) as? [[String: Any]] else {
    print(mode == "displays" ? 0 : -1)
    exit(0)
}

if mode == "displays" {
    print(displays.count)
    exit(0)
}

let active = SLSGetActiveSpace(cid)
var index = 0
var found = -1

for display in displays {
    guard let spaces = display["Spaces"] as? [[String: Any]] else { continue }
    for space in spaces {
        let type = (space["type"] as? Int) ?? 0
        if type != 0 { continue }  // 跳过全屏空间(type 4)，只数普通桌面
        index += 1
        let id64 = (space["id64"] as? UInt64) ?? (space["ManagedSpaceID"] as? UInt64) ?? 0
        if id64 == active {
            found = index
        }
    }
}

print(found)
