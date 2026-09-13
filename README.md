# RLS · 让 AI 少读 90% 代码，找到的每一行都能核对

> **二进制分发仓（无源码）** · 英文版：[README.en.md](README.en.md) · 免费试用 · Windows x64 优先
>
> RLS（Rust Local Search）是本地运行的代码搜索与结构分析工具：**一个 `rls.exe`，两种用法** —— 人在终端用 CLI，AI（Claude Code / Codex 等）走 HTTP MCP，查的是同一套索引、同一套结果。

```powershell
# 60 秒试用
.\rls.exe search "retry_with_backoff" --scope D:\your-project --compact
.\rls.exe outline D:\your-project\src --max-files 50
.\rls.exe context D:\your-project\src\retry.py 45
```

⭐ 如果它帮你省了 token / 省了翻文件的时间，请给个 Star —— 这是闭源项目唯一的公开反馈通道。
🐟 企业版 / 私有部署 / 定制语言支持：见 [CONTACT.md](CONTACT.md)。

---

## 为什么需要 RLS？一句话

AI 写代码真正的成本不是“找不到一行字”，而是 **Grep → Read × N 反复翻文件、补上下文、猜调用关系**。

RLS 把这条路径收敛成一条：

```text
定位符号或文件 → 查看结构和定义 → 按需追踪调用 / 实现 / 数据流
```

先返回**文件 + 符号 + 行号**，AI 只深读真正相关的代码。

## 5 个工具，闭环

| 工具 | 干什么 | 一句话 |
| --- | --- | --- |
| `search` | 按标识符字面精确定位定义/引用 | 不要正则，不要猜，`def/ref/all` 可限 |
| `outline` | 文件/目录结构地图 | 先建地图，再下手 |
| `context` | 按 `文件+行号` 展开所在定义 | 带源码、调用者/被调用者 |
| `trace` | 调用路径 / 实现 / 数据流 / 对比 | 按证据图走，支持 `--compact` 分页 |
| `handover` | 项目交接事实预取 | 换人/换 AI，一条命令交接 |

详细参数与示例：[docs/FEATURES.md](docs/FEATURES.md) · AI 写法：[docs/BEST-PRACTICES.md](docs/BEST-PRACTICES.md)

## 实测效果（可复现，不是口号）

> 完整 AI 实测过程见 [docs/TRIAL-REPORT.md](docs/TRIAL-REPORT.md)：95 文件 Rust/Python/TS 混合仓，`search→context→ref` 3 步约 80 ms 从未知符号到定义+调用清单；25 文件脏乱仓同名 3 定义一眼分清。缺点也写在里面了，先看再 Star。

Windows x64、50 个 Rust 文件、预热 5 次采样 30 次，一次 p95：

| 场景 | p95 |
| --- | ---: |
| 冷启动建索引 | 53.61 ms |
| 暖查询 | 20.27 ms |
| 精确搜索 | 3.74 ms |
| `trace` 4K 受限输出 | 29.93 ms（约 928 Token） |

更大规模生成样例：500 文件冷启动 324 ms / 暖查 27 ms；5,000 文件冷启动 2.96 s / 暖查 91 ms。

固定任务样例 Token 估算：精确搜索+补读省约 84.5%，目录概览省约 85.9%，深入查看省约 95.0%，合计约 91.3%。**这是参考量级，不是固定承诺**，复现方法见 [docs/BENCHMARKS.md](docs/BENCHMARKS.md)。

设计依据：33 个真实会话、11,560 次工具调用分析，Read+Grep 占约 50% token，典型浪费就是 Grep→Read×N（317 次）。语义/向量搜索使用率仅 0.9%，所以 RLS 选了**精确搜索 + AST 调用图**，不要 embedding、不要模型服务。见 [docs/WHY-RLS.md](docs/WHY-RLS.md)。

## 3 分钟上手

### 1. 下载

去 [www.swancat.com](https://www.swancat.com) 找下载入口，下载最新 `rls-vX.Y.Z-windows-x64.zip`，解压得到 `rls.exe`（单个文件，无其他依赖）。本仓只放文档，不放安装包。

校验（SHA256 见下载页，公仓 [CHANGELOG.md](CHANGELOG.md) 同步记录）：

```powershell
Get-FileHash .\rls-vX.Y.Z-windows-x64.zip -Algorithm SHA256
```

或用仓里脚本：`powershell -File scripts\verify-download.ps1 -ZipPath .\rls-vX.Y.Z-windows-x64.zip -ExpectedSha256 <值>`

### 2. 人用 CLI

```powershell
.\rls.exe --help
.\rls.exe search "handle" --scope D:\your-project --compact --json
.\rls.exe doctor --json
```

### 3. 给 AI 用（HTTP MCP）

```powershell
.\rls.exe install
.\rls.exe service start
.\rls.exe status --json
# MCP 地址：http://127.0.0.1:8765/
```

```powershell
codex mcp get rls --json
claude mcp get rls
```

只想手动跑：`rls http 127.0.0.1 8765`。索引首次访问自动建、源码变化自动刷，不用手工维护。

## 支持语言

结构化解析：Rust、Python、JavaScript、TypeScript、Go、Java、C、C++；其他文件仍可文本搜索。

## 对比一眼看

* vs `grep/rg`：它们只给文本行，RLS 给**符号+定义+调用关系+快照证据**。
* vs VS Code 符号跳转：只服务一个人，RLS 同时服务 **CLI 人 + MCP 的 AI**，结果可进 prompt 可核对。
* vs 向量/embedding 搜索：要模型、要服务、结果不可核对；RLS **本地、零模型依赖、字面精确、可回源码**。

全文：[docs/COMPARISON.md](docs/COMPARISON.md)

## 常见问题

* **开源吗？** 不开源。本仓只有二进制与文档，源码在私有仓。许可证见 [LICENSE](LICENSE)。
* **会上传我的代码吗？** 不会。默认只监听 `127.0.0.1`，索引在本地（`%APPDATA%\rls` / `~/.config/rls` + 本地数据目录）。
* **支持 macOS/Linux 吗？** 内核跨平台，首发 Windows x64 包，其他平台按需求排期——想要就去 Issue 投票。
* **和现有 Agent 冲突吗？** 不冲突，它只是 MCP 工具 + CLI，不接管你的 Agent。

更多：[docs/FAQ.md](docs/FAQ.md)

## 路线图（公开部分）

* [x] 单文件 `rls.exe`，CLI + HTTP MCP 同索引
* [x] search / outline / context / trace / handover 五工具
* [x] 8 语言结构化解析 + 可复现基准
* [ ] 更多语言 / 更大仓优化（按 Issue 热度排）
* [ ] 企业版：团队共享索引、权限、审计、私有部署

想要什么功能？**去 Issue 投票，Star 数 + 真实场景描述决定优先级。**

## 反馈与商务

* Bug / 场景 / 语言支持请求 → GitHub Issue（请贴 `rls doctor --json` + 最小复现步骤，不要贴涉密代码）
* 企业合作 / 投资 / 大客户定制 → [CONTACT.md](CONTACT.md)，附上你的仓规模、语言、Agent 类型，我们单独聊。

---
*本仓不含源码。下载即表示同意 [LICENSE](LICENSE) 试用条款。*
