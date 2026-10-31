# SuntimesWidget — 中文翻译修正 + 仅中英文（自用）

本分支只含**补丁与脚本**，不含上游源码。基于上游 `forrestguice/SuntimesWidget` master（0.17.6）。

## 内容

| 文件 | 用途 |
|---|---|
| `patches/zh-translation.patch` | 简体中文术语与误译修正（44 处） |
| `patches/signing.patch` | release 改用 `key.properties` 自用签名（口令不入库） |
| `patches/repos.patch` | `maven.google.com` → `dl.google.com`（部分网络环境该别名不可达） |
| `scripts/prune-languages.sh` | 仅保留中文与英文语言资源，删除其余 250 个语言目录 |
| `scripts/apply-patches.sh` | 幂等应用/检查上述补丁与裁剪 |
| `scripts/check.sh` | 供构建流水线调用 |

## 中文修正摘要

- **高度角 vs 海拔**：`altitude` 统一为“高度角”（原“查找海拔/海拔图/太阳(海拔)”），`elevation` 保留“海拔”并明确为“观测者海拔”
- **晨昏蒙影**：`twilight` 三级统一为“天文/航海/民用晨昏蒙影”（原拆成“天文曙光/天文暮光”等 6 种）
- **月球中天**：`lunar noon/midnight` 统一为“月球中天/月球午夜”（原“月亮正午/太阴正午/太阴子夜”）
- **Seek X**：统一为“跳转到 X”（原“寻觅黎明/黄昏/正午”）
- **术语**：`Data Source`→“数据来源”（原“日期来源”）；`implicit intent`→“隐式意图”（原“默认意图”）；`pay as you like`→“按意愿付费”（原“随意付费”）
- 去掉“您确定您想要…”“需要被重新指派”等直译腔

## 用法

在上游源码树根目录：

```bash
git submodule update --init --recursive        # 需要 lib-quadflask-colorpicker
scripts/apply-patches.sh apply                 # 打补丁 + 裁语言
scripts/apply-patches.sh check                 # 只检查
```

本地准备（不入库）：`key.properties`（600）指向自用 keystore。
