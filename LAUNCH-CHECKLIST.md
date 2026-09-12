# GitHub 上线清单（按顺序执行）

## P0 先保闭源（5 分钟）

- [ ] `D:\rust-prj\rls` 的 `Cargo.toml`：去掉 `license="MIT"`，`repository` 改真实地址，加 `publish=false`
- [ ] `README.md` 尾部“MIT”改成版权所有试用声明
- [ ] 检查无密钥：`config/local.toml`、`data/` 都在 `.gitignore` 里，已确认，只要别 `git add -f` 就行

## P1 建两个仓（10 分钟，网页操作，本机没 `gh`）

- [ ] github.com 新建**私有**空仓 `rls`（别勾 README）
- [ ] github.com 新建**公开**空仓 `rls-dist`（别勾 README）
- [ ] 把联系方式换成真的：`rls-dist/CONTACT.md` 里邮箱和微信占位符

## P2 推代码（10 分钟）

```powershell
cd D:\rust-prj\rls
git remote add origin git@github.com:<你>/rls.git
git push -u origin master

cd D:\rust-prj\rls-dist
git remote add origin git@github.com:<你>/rls-dist.git
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

- [ ] 去 `rls-dist` 网页点 **Releases → Draft new release**，tag 写 `v0.1.0`，传 zip，notes 贴 `CHANGELOG.md` + SHA256 + README 里 60 秒 3 条命令
- [ ] `rls-dist` 的 `CHANGELOG.md` 把 SHA256 补上再推一次

## P4 验收（5 分钟）

- [ ] 找台干净目录按 README 走一遍 60 秒试用，确认能跑
- [ ] 公开仓搜一遍确认无源码：只有 README/docs/zip，没有 `crates/`
- [ ] 给 `rls-dist` 点第一个 Star，截个图发社区
