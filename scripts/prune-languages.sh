#!/bin/bash
# 只保留中文和英文的语言资源，删除其余 values-<locale> 目录。
# 保留：values(默认英文)、values-zh*(简体/繁体/各地)、values-en*，以及所有非语言限定符
# （v21/night/sw600dp/ldrtl/watch/television 等）。幂等：已删的目录不会再报错。
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$HERE/src"; [ -d "$ROOT/app" ] || ROOT="$(cd "$HERE/.." && pwd)"
RES="$ROOT/app/src/main/res"
python3 - "$RES" <<'PY'
import os, re, shutil, sys
res = sys.argv[1]
QUAL = re.compile(r'^(v\d+|night(-\w+)?|sw\d+dp|w\d+dp|h\d+dp|land|port|ldrtl(-\w+)?|watch|television|car|round|notround|anydpi(-\w+)?|mcc\d+(-\w+)?|mnc\d+(-\w+)?|\d+dpi|b\+.*)$')
LANG = re.compile(r'^([a-z]{2,3})(-r[A-Za-z]{2,4})?$')
pruned = kept = 0
for d in sorted(os.listdir(res)):
    if not d.startswith('values'):
        continue
    if d == 'values':
        kept += 1; continue
    rest = d[len('values-'):]
    first = rest.split('-')[0]
    if rest.startswith('b+') or QUAL.match(rest) or QUAL.match(first):
        kept += 1; continue
    m = LANG.match(rest)
    if m and m.group(1) not in ('zh', 'en'):
        shutil.rmtree(os.path.join(res, d)); pruned += 1
    else:
        kept += 1
print(f"  [ok] 语言裁剪: 删除 {pruned} 个, 保留 {kept} 个 values-* 目录")
PY
