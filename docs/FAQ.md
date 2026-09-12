# FAQ

**Q：开源吗？**
A：不开源。本仓只有二进制与文档，源码在私有仓。下载即同意 LICENSE 试用条款。

**Q：会上传我的代码吗？**
A：不会。默认 `127.0.0.1`，索引在本地。配置在 `%APPDATA%\rls\config.toml`（Win）/ `~/.config/rls`（Linux）等。

**Q：怎么装？**
A：Releases 下 zip → 解压得 `rls.exe` → `.\rls.exe install` → `.\rls.exe service start` → `.\rls.exe status --json`。MCP 地址 `http://127.0.0.1:8765/`。

**Q：Claude Code / Codex 怎么接？**
A：`codex mcp get rls --json` / `claude mcp get rls` 检查；`install` 会尝试写用户级 MCP 条目，失败就手工按下址添加。

**Q：支持哪些语言？**
A：结构化：Rust / Python / JS / TS / Go / Java / C / C++；其他文本可搜。

**Q：搜不到怎么办？**
A：先确认 scope 对不对、是否用了自然语言问句（只收字面词）、是否被 include/exclude 过滤；`kind=ref` 无建议是正常的；改完代码重查一次。

**Q：trace 分页失败？**
A：保留原查询参数只换 cursor；`TRACE_CURSOR_STALE` 按 `next_step.arguments` 原样重发无 cursor 请求。

**Q：macOS/Linux 包？**
A：内核跨平台，首发 Win x64。去 Issue 投票要哪个平台，附文件数+语言。

**Q：能商用吗？**
A：可免费试用与内部评估。分发/转售/捆绑/OEM、私有部署要授权，走 CONTACT.md。

**Q：提 Issue 要带什么？**
A：`rls doctor --json`、复现步骤、期望 vs 实际。别贴涉密代码，给最小复现。
