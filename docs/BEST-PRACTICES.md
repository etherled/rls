# AI 最佳实践：定位后深读（省 token 的正确姿势）

> 目标：把 5–10 轮 Grep→Read 压到 2–3 轮。实测固定任务省约 91.3% token（参考量级）。

## 推荐工作流（每次都这样）

1. **定位**：短标识符 `search`，或 `outline` 建地图。第一轮加 `--compact`，只留文件/符号/行号。
2. **深读**：选中 1–3 个位置，用 `context 文件 行号` 读定义和局部调用关系。
3. **追踪**：只有要解释影响范围/实现/数据流时才 `trace`，先 `--summary --compact`。
4. **改后重查**：改完源码重跑原查询，让索引自动刷，再确认行号是否有效。

```powershell
# 示例：从名字到影响范围
rls search "ensure_fresh" --scope src --compact --json
rls context src\lib.rs 120 --json
rls trace --intent call_path --from "file=src\\lib.rs,line=120" --scope . --summary --json
```

## 控制范围和输出

* 永远传 `--scope`（项目目录），别全盘搜。
* `--kind def` 先找定义，`--kind ref` 再找引用。
* `--include/--exclude` 过滤生成物、依赖、测试数据。
* 结果多先降 `--max-results`，再逐步放大；被截断按 `continuation/cursor` 翻页，别直接全量重查。

## 保持结论可靠

* `search` 只收字面词，别把自然语言问题粘进去。
* `suggestions` / `candidate` / `unresolved` 不是证据，必须重搜或回源码确认。
* 空 `callers/callees` ≠ 运行时不存在；涉及运行时行为，结合编译和测试。
* 多 Agent 共用一个 HTTP 服务时，每个项目传清路径/workspace。
* 把文件路径+行号+snapshot 写进 commit / PR / 审查记录。

## 给 Agent 的 MCP 提示词片段（可直接贴）

```text
Use RLS MCP with locate-then-read:
1. search(short identifier, compact) or outline(dir).
2. context(file, line) for 1-3 hits only.
3. trace(summary, compact) only for impact/data-flow.
4. Always pass explicit scope; never treat suggestions/candidates as proven.
5. Cite file:line + snapshot_id in every conclusion.
```

## 反模式（别这样）

* ❌ 一上来 `trace --depth 8` 全量拉 → ✅ 先 compact + summary。
* ❌ 把 `suggestions` 当命中写代码 → ✅ 重搜确认。
* ❌ 无 scope 全仓搜 → ✅ 先 outline 缩小目录。
* ❌ 读了 20 个文件再动手 → ✅ 先 3 个 context，不够再补。
