# AI 实测报告：两个真实仓（可复现步骤）

> 测试者就是 AI agent，走的是 MCP 真实路径，不是录好的 demo。
> 下面每个数字都是服务端实测耗时（`took_ms`），每个结论都带文件行号，可在你机器上重跑验证。

## 仓 A：hirouter（95 个源码文件，Rust 37 + Python 41 + TS/TSX 17）

有 git 历史、有 Codex 会话、worktree 还有 8 个未提交修改——典型的“正在干活的仓”。

**任务：`codex_session_hash` 在哪定义？谁在用？**

| 步骤 | 调用 | 服务端耗时 | 得到什么 |
| --- | --- | --- | --- |
| 1. 定位 | `search "codex_session_hash"` | 30 ms | 18 处命中，定义在 `capture.rs:121` |
| 2. 深读 | `context capture.rs:121` | 27 ms | 定义源码 + 被调 1 次，**调用者 0** |
| 3. 核对 | `search kind=ref` | 26 ms | 8 处文本引用，逐个确认 |

3 步、共约 80 ms，结论：定义唯一，静态调用图里 0 调用者，但有 8 处文本引用需人工确认（动态调用/跨边界，RLS 不硬编边，而是如实报空 + 给 ref 清单）。

附带：目录 `outline` 一次返回 14 个文件结构；故意打错 `codex_sesion_hash` 返回 0 命中——**不猜、不模糊、不 hallucinating**，打错就如实说没有。

## 仓 B：SDR2HDR（25 个源码文件，Python 22 + C/C++ 3，worktree 脏：91 改 + 81 未跟踪）

杂乱仓，`.py`/`cpp`/`c` 混杂，还有一堆 `_tmp_/_probe_` 临时文件——考验索引是否被垃圾文件带偏。

**任务 1：`pq_encode_from_nits` 定义与调用**

| 步骤 | 调用 | 服务端耗时 | 得到什么 |
| --- | --- | --- | --- |
| 1. 定位 | `search` | 29 ms | 10 处命中 |
| 2. 深读 | `context dci_tiff_utils.py:96` | 27 ms | 定义 + 调用者 1 |
| 3. 追影响 | `trace call_path depth=2` | 即时 | `edges=0 gaps=3`，如实报 gap 并给 `next_step=context` |

**任务 2：`srgb_to_linear` 同名多定义**

`search kind=def` 28 ms 返回 9 处命中——3 个文件各自定义（`analyze_overexposure.py:21`、`check_output_image.py:6`、`check_sdr_luminance.py:5`）。传统 grep 给你 9 行文本自己猜，RLS 直接告诉你**哪几个是定义、行号各在哪**。

## 诚实声明（缺点先说）

1. **静态调用图是保守的**：动态语言（Python 回调、字符串反射）解析不到的边，`callers` 就报 0，不编造。用 `kind=ref` 二次确认，这是设计不是 bug。
2. **`trace` 遇到解不出的关系就报 `gap`**，并告诉你下一步调什么工具。它不负责“显得聪明”，负责“不骗你”。
3. **只认字面精确查询**：自然语言问句、拼写错误直接 0 结果。先 `outline` 建地图，再短标识符搜。
4. 以上耗时是服务端索引命中时间，不含网络；冷启动首次建索引另算（50 文件约 50 ms 量级，见 BENCHMARKS）。

## 和传统方式对比（同一个任务）

* 传统：`grep codex_session_hash` → 18 行 → 逐个 `Read`（大文件 900–2400 行）→ 猜哪个是定义 → 再 grep 调用者。约 5–10 轮，读进上万行无关代码。
* RLS：`search → context → ref`，3 轮，读的只有定义本身 + 8 个引用点。

省的不是搜索那 30 ms，省的是**少读的几万行代码和 token**。
