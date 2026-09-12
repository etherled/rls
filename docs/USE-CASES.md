# 使用场景（拿来即用）

## 1. AI 改 bug：从报错名到影响面

```powershell
rls search "panic_name" --scope src --compact --json
rls context src\a.rs 88 --json
rls trace --intent call_path --from "file=src\\a.rs,line=88" --scope . --summary --json
```

## 2. 接手陌生仓：10 分钟建地图

```powershell
rls outline D:\proj\src --max-files 100 --max-depth 2
rls handover D:\proj --history-source none
```

`handover` 给人/AI 交接都管用。

## 3. 重构前看 blast radius

```powershell
rls trace --intent implementation --entry ensure_fresh --scope . --depth 3 --summary --json
```

先看结论、边数、缺口，再决定改几处。

## 4. 人肉 CLI：脚本与诊断

```powershell
rls search "TODO" --scope src --kind ref --compact
rls doctor --json
rls status --json
```

## 5. 团队/企业（走商务）

共享索引、权限审计、内网离线、私有 MCP 扩展——见 [CONTACT](../CONTACT.md)。
