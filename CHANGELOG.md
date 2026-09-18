# Changelog（分发版，只记二进制变化）

格式：`## vX.Y.Z - YYYY-MM-DD` + 变更 + 下载链接 + SHA256。

## v0.1.0 - 2026-09-13

* 首个公开试用包：Windows x64 单文件 `rls.exe`
* CLI + HTTP MCP（`http://127.0.0.1:8765/`），search / outline / context / trace / handover
* 8 语言结构化解析：Rust / Python / JS / TS / Go / Java / C / C++
* 下载：本地已打好 `rls-v0.1.0-windows-x64.zip`（5,484,252 字节），等 Phase 5 的 rls.swancat.com 下载页建好后上传，公开仓不放安装包
* SHA256：`5A9AD85E210FD6A0FB7A640FF76F5C02B6A0020651B27E06B461A25765F71B6E`

## v0.1.0（2026-09-18 同号重打，不换号）

* MCP 修 bug：业务错误不再被 -32602 掩盖、union outputSchema/hints 修复、TraceTarget 兼容被转成字符串的 JSON 对象；19 项复验全过
* 下载：`rls-v0.1.0-windows-x64.zip`（5,494,695 字节）
* SHA256：`8E529237805A2E2506492BB5E74B1B678B42A5AE3AEA57E2CE3643F051AA3BCD`
