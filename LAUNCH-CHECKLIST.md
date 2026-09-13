# GitHub 上线清单（按顺序执行）

## P0 先保闭源（5 分钟）

- [ ] `D:\rust-prj\rls` 的 `Cargo.toml`：去掉 `license="MIT"`，`repository` 改真实地址，加 `publish=false`
- [x] `D:\rust-prj\rls` 的 `Cargo.toml`（已改好）：删掉 `license="MIT"`，`repository` 改私有仓地址 `https://github.com/etherled/rls-src`，加 `publish=false`
- [x] `README.md` 许可证一节已改成版权所有试用声明（已改好）

## P1 建两个仓（10 分钟，网页操作，本机没 `gh`）

- [x] github.com 新建**私有**空仓 `rls-src`（账号 etherled，别勾 README）（2026-09-13 已建好）
- [x] github.com 新建**公开**空仓 `rls`（账号 etherled，别勾 README）（2026-09-13 已建好，旧仓 local-mcp-search 已删）
- [x] 把联系方式换成真的（已改好 yyyx@sina.com / YangJie_3192）：`rls-dist/CONTACT.md` 里占位符已换

## P2 推代码（10 分钟）

```powershell
cd D:\rust-prj\rls
git remote add origin git@github.com:etherled/rls-src.git
git push -u origin master

cd D:\rust-prj\rls-dist
git remote add origin git@github.com:etherled/rls.git
git push -u origin main
```

## P3 打首个试用包（20 分钟）

```powershell
cd D:\rust-prj\rls
cargo build --release   # 如报文件被锁，先停掉正在跑的 rls.exe 再编
.\target\release\rls.exe --help
Compress-Archive -Path .\target\release\rls.exe -DestinationPath .\rls-v0.1.0-windows-x64.zip -Force
Get-FileHash .\rls-v0.1.0-windows-x64.zip -Algorithm SHA256
```

- [x] v0.1.0 zip 在本地保管好（2026-09-13 已打出，5,484,252 字节，SHA256 `5A9AD85E…71B6E`，不进仓）；等 Phase 5 的 rls.swancat.com 下载页建好后上传（方案 B，注册用户可下载）；下载页 notes 贴 CHANGELOG 加 SHA256 加 README 里 60 秒 3 条命令
- [x] 公开仓 `rls` 的 `CHANGELOG.md` 把 SHA256 补上再推一次（2026-09-13 已补已推）

## P4 验收（5 分钟）

- [x] 找台干净目录按 README 走一遍 60 秒试用，确认能跑（2026-09-13 干净目录 search/outline/context 全通）
- [x] 公开仓搜一遍确认无源码、无安装包：只有 README/docs，没有 `crates/`，没有 exe/zip（安装包只放 rls.swancat.com）（2026-09-13 已验，guard.yml 同口径）
- [ ] 给公开仓 `rls` 点第一个 Star，截个图发社区（待用户手动）
