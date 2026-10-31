#!/bin/bash
# 供 bin/proj-index --audit 调用：确认 SuntimesWidget 的翻译/语言/签名补丁没有丢失。
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$HERE/apply-patches.sh" check
