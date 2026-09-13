---
name: Bug 反馈 / Bug report
about: 跑不起来、结果不对、崩了，走这个模板
title: "[bug] "
labels: bug
assignees: ''
---

## 客户端类型 / Client

- rls 版本（`rls.exe --version` 或 `doctor --json` 输出）：
- 系统：如 Windows 11 x64 / 其他：
- 使用方式：CLI / HTTP MCP（Claude Code / Codex / 手动 `rls http`）：
- 项目规模（大概文件数 + 语言，如 95 文件 Rust/Python/TS）：

## 复现步骤 / Steps to reproduce

1.
2.
3.

```powershell
# 把你跑的完整命令贴这里
.\rls.exe search "..." --scope D:\your-project --compact --json
```

## 期望 vs 实际 / Expected vs Actual

- 期望：
- 实际：

## 日志 / Logs

<!-- 只贴 rls 自己的输出，不要贴你的源码和密钥。先跑 doctor 看看环境。 -->

```powershell
.\rls.exe doctor --json
```

```text
把报错输出 / stderr 日志贴这里（-= JSON-RPC stdout 保持干净，广告只走 stderr =- 与本 bug 无关不用管）
```

## 补充 / Extra

- 能否稳定复现：是 / 偶发：
- 截图（如有）：
