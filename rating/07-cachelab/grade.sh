#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$SCRIPT_DIR/../../proj/07-cachelab" && pwd)}"
cd "$PROJECT_DIR"
make

csim_output="$(./test-csim || true)"
printf '%s\n' "$csim_output"
csim_line="$(grep 'TEST_CSIM_RESULTS' <<<"$csim_output" | tail -n 1 || true)"
csim_score="$(grep -oE '[0-9]+' <<<"$csim_line" | head -n 1 || true)"
csim_score="${csim_score:-0}"

run_trans() {
  local m="$1" n="$2"
  ./test-trans -M "$m" -N "$n" | grep 'TEST_TRANS_RESULTS' | tail -n 1 || true
}

line32="$(run_trans 32 32)"
line64="$(run_trans 64 64)"
line61="$(run_trans 61 67)"

readarray -t r32 < <(grep -oE '[0-9]+' <<<"$line32")
readarray -t r64 < <(grep -oE '[0-9]+' <<<"$line64")
readarray -t r61 < <(grep -oE '[0-9]+' <<<"$line61")

score="$(awk -v cs="$csim_score" \
  -v c32="${r32[0]:-0}" -v m32="${r32[1]:-2147483647}" \
  -v c64="${r64[0]:-0}" -v m64="${r64[1]:-2147483647}" \
  -v c61="${r61[0]:-0}" -v m61="${r61[1]:-2147483647}" '
function pts(m, lo, hi, full, ok) {
  if (!ok || m >= hi) return 0
  if (m <= lo) return full
  return (1 - (m-lo)/(hi-lo))*full
}
BEGIN {
  s32=pts(m32,300,600,8,c32); s64=pts(m64,1300,2000,8,c64); s61=pts(m61,2000,3000,10,c61)
  printf "Csim: %.1f/27\nTranspose 32x32: %.1f/8 (%d misses)\nTranspose 64x64: %.1f/8 (%d misses)\nTranspose 61x67: %.1f/10 (%d misses)\nAutomated total: %.1f/53\n", cs,s32,m32,s64,m64,s61,m61,cs+s32+s64+s61
}')"
printf '\n%s\n' "$score"
echo 'Manual review: 7 style points; official total: 60.'
