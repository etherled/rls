# RLS · Let AI read 90% less code, every hit verifiable

> **Binary-only distribution (no source)** · 中文版：[README.md](README.md) · Free trial · Windows x64 first
>
> RLS (Rust Local Search) runs locally: **one `rls.exe`, two interfaces** — humans use the CLI, AI agents (Claude Code / Codex, …) use HTTP MCP against the same index and result semantics.

```powershell
# 60-second trial
.\rls.exe search "retry_with_backoff" --scope D:\your-project --compact
.\rls.exe outline D:\your-project\src --max-files 50
.\rls.exe context D:\your-project\src\retry.py 45
```

⭐ If it saves you tokens / file reads, please Star — for a closed-source project this is the public feedback channel.
🐟 Enterprise / on-prem / custom languages: see [CONTACT.md](CONTACT.md).

## Why RLS?

AI coding cost is rarely "can't find one line" — it is **Grep → Read × N, refilling context and guessing call graphs**.

RLS collapses it to:

```text
Locate symbol/file → inspect structure/definition → trace calls / impl / data-flow on demand
```

Return **file + symbol + line** first; let AI deep-read only what matters.

## Five tools

| Tool | Does | Note |
| --- | --- | --- |
| `search` | exact literal locate of defs/refs | `def/ref/all`, no regex |
| `outline` | file/directory structure map | map first |
| `context` | expand enclosing definition at `file+line` | source + callers/callees |
| `trace` | call path / implementation / data-flow / compare | evidence graph, `--compact` paging |
| `handover` | project handover fact prefetch | one command to hand over |

Details: [docs/FEATURES.md](docs/FEATURES.md), [docs/BEST-PRACTICES.md](docs/BEST-PRACTICES.md).

## Measured results (reproducible)

> Full AI trial walkthrough (in Chinese): [docs/TRIAL-REPORT.md](docs/TRIAL-REPORT.md) — 95-file mixed Rust/Python/TS repo, unknown symbol to def+callers in 3 calls ≈ 80 ms; honest limitations included.

Windows x64, 50 Rust files, 5 warmups, 30 samples (p95):

| Scenario | p95 |
| --- | ---: |
| Cold-start index | 53.61 ms |
| Warm query | 20.27 ms |
| Exact search | 3.74 ms |
| `trace` 4K bounded | 29.93 ms (~928 tokens) |

500 files: cold 324 ms / warm 27 ms. 5,000 files: cold 2.96 s / warm 91 ms.

Token estimate on fixed tasks: search+reads −84.5%, overview −85.9%, deep inspect −95.0%, total −91.3%. **Magnitude reference, not a promise.** Repro: [docs/BENCHMARKS.md](docs/BENCHMARKS.md).

## Quickstart

1. Download `rls-vX.Y.Z-windows-x64.zip` from **Releases**, unzip to get single-file `rls.exe`.
2. Verify SHA256 published on the release page.
3. CLI: `.\rls.exe --help`, `.\rls.exe doctor --json`.
4. MCP for AI: `.\rls.exe install`, `.\rls.exe service start`, endpoint `http://127.0.0.1:8765/`.

Structured languages: Rust, Python, JavaScript, TypeScript, Go, Java, C, C++. Others remain text-searchable.

## FAQ (short)

* **Open source?** No. Binary + docs only. See [LICENSE](LICENSE).
* **Does it upload my code?** No. Listens on `127.0.0.1` by default, index stays local.
* **macOS/Linux?** Core is cross-platform; Windows x64 ships first. Vote in Issues.
* **Conflicts with my agent?** No, it is just an MCP tool + CLI.

More: [docs/FAQ.md](docs/FAQ.md), comparisons: [docs/COMPARISON.md](docs/COMPARISON.md).

---
*This repo contains no source code. Downloading means you accept [LICENSE](LICENSE).*
