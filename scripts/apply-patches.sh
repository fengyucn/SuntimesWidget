#!/bin/bash
# SuntimesWidget 自用补丁：中文术语修正 + 自用签名 + 仅保留中英文语言。
# 用法: projects/suntimes/apply-patches.sh check|apply
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$HERE/src"; [ -d "$ROOT/app" ] || ROOT="$(cd "$HERE/.." && pwd)"
SRC="$ROOT"
ACTION="${1:-check}"
PD="$HERE/patches"; [ -d "$PD" ] || PD="$(cd "$HERE/.." && pwd)/patches"
PATCHES=("zh-translation.patch" "signing.patch" "repos.patch")

applied() {
    grep -q "晨昏蒙影" "$SRC/app/src/main/res/values-zh-rCN/strings.xml" 2>/dev/null &&
        grep -q "signingConfigs" "$SRC/app/build.gradle" 2>/dev/null &&
        grep -q "dl.google.com/dl/android/maven2" "$SRC/build.gradle" 2>/dev/null
}

case "$ACTION" in
    check)
        applied && echo "[ok] suntimes 补丁已应用" || { echo "[fail] suntimes 补丁缺失"; exit 1; }
        n=$(ls "$SRC/app/src/main/res" | grep -cE '^values-[a-z]{2,3}(-r[A-Za-z]{2,4})?$' || true)
        [ "$n" -le 60 ] && echo "[ok] 语言目录已裁剪 (剩 $n 个语言变体)" || { echo "[fail] 语言目录未裁剪 ($n)"; exit 1; }
        ;;
    apply)
        for p in "${PATCHES[@]}"; do
            if patch -d "$SRC" -p1 -R --dry-run -s -f < "$PD/$p" >/dev/null 2>&1; then
                echo "[ok] $p 已应用"
            elif patch -d "$SRC" -p1 --dry-run -s -f < "$PD/$p" >/dev/null 2>&1; then
                patch -d "$SRC" -p1 -s -f < "$PD/$p" && echo "[ok] $p 应用"
            else
                echo "[fail] $p 无法干净应用（上游相关文件变了）— 手工合并后重新生成"; exit 1
            fi
        done
        "$HERE/prune-languages.sh"
        ;;
    *) echo "用法: $0 check|apply"; exit 2 ;;
esac
