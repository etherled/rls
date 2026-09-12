# 功能特点：一个 exe，两种用法，五种能力

## 1. 单文件、本地、自维护

* 单个 `rls.exe`，无 Python / Node / 模型依赖。
* 默认只监听 `127.0.0.1`，源码和索引留在本机。
* 首次访问项目自动建索引，源码变化自动刷新，不用手工 `index add`。
* Windows 支持登录自启动（`RLS MCP.vbs`），CLI 与 MCP 共用同一索引和结果语义。

## 2. 五工具闭环（CLI 与 MCP 同名同义）

### search：精确定位

```powershell
rls search "retry_with_backoff" --scope src --json
rls search "retry_with_backoff" --scope src --kind def --source-only --compact --json
```

* 字面精确匹配，不支持正则/自然语言问句。
* `--kind def|ref|all`，`ref` 只返引用。
* 精确结果少时 `suggestions` 只是候选名，必须重搜确认，不能当证据。

### outline：结构地图

```powershell
rls outline src\retry.py --json --compact
rls outline src --include-tests --max-files 100 --max-depth 2
```

* 列文件符号/导入/行范围，或分页看目录。
* 不知道定义在哪时，先用它建地图。

### context：定点深读

```powershell
rls context src\retry.py 45 --json
rls context src\retry.py 45 --json --diagnostic --include-snapshot
```

* 按 1-based 行号展开所在函数/类/方法/常量。
* 返回源码 + 调用者/被调用者，诊断模式可带快照。

### trace：关系追踪

```powershell
rls trace --intent implementation --entry ensure_fresh --scope . --depth 3 --json
rls trace --intent call_path --from "file=src\\lib.rs,line=10" --scope . --summary --json
```

* intent：`definition` / `call_path` / `implementation` / `data_flow` / `compare` / `asset_metadata`。
* `--compact` + `--max-bytes 4096-1048576` 受限输出，`continuation.cursor` 分页；`TRACE_CURSOR_STALE` 按 `next_step.arguments` 重试。
* `--summary` 给结论、路径节点、证据状态、缺口和下一步。

### handover：交接预取

```powershell
rls handover D:\projects\foo --history-source none
```

* 预取仓库元数据与会话来源说明，固定纯文本报告，不执行项目命令。

## 3. 语言与输出

* 结构化解析：Rust / Python / JavaScript / TypeScript / Go / Java / C / C++；其余文件文本可搜。
* CLI/MCP 均支持文本、JSON、紧凑结果、受限输出；给 AI 用统一加 `--json`，要短加 `--compact`。
* 每个结论带文件、行号、快照标识，方便写进修改记录与审查。

## 4. 管理命令

```powershell
rls index status
rls status --json
rls doctor --json
rls doctor --fix
rls config show
rls service status/start/restart
```

配置文件：Windows `%APPDATA%\rls\config.toml`，Linux `~/.config/rls/config.toml`，macOS `~/Library/Application Support/rls/config.toml`。
