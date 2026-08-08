#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$SCRIPT_DIR/../../proj/09-shlab" && pwd)}"
cd "$PROJECT_DIR"
make

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
score=0

normalize() {
  local trace_no="$1"
  sed -E 's/pid=[0-9]+/pid=<PID>/g; s/\([0-9]+\)/(<PID>)/g' |
    if (( trace_no >= 11 && trace_no <= 13 )); then
      sed -E 's/[0-9]+/<N>/g'
    else
      cat
    fi
}

for i in $(seq -w 1 16); do
  timeout 20s ./sdriver.pl -t "trace${i}.txt" -s ./tsh -a '-p' >"$tmpdir/student-$i" 2>&1 || true
  timeout 20s ./sdriver.pl -t "trace${i}.txt" -s ./tshref -a '-p' >"$tmpdir/ref-$i" 2>&1 || true
  n=$((10#$i))
  normalize "$n" <"$tmpdir/student-$i" >"$tmpdir/student-$i.norm"
  normalize "$n" <"$tmpdir/ref-$i" >"$tmpdir/ref-$i.norm"
  if diff -q "$tmpdir/student-$i.norm" "$tmpdir/ref-$i.norm" >/dev/null; then
    score=$((score + 5))
    echo "trace$i: PASS (5/5)"
  else
    echo "trace$i: FAIL (0/5)"
    diff -u "$tmpdir/ref-$i.norm" "$tmpdir/student-$i.norm" | head -n 20 || true
  fi
done

printf '\nShell Lab automated score: %d/80\n' "$score"
echo 'Manual review: 10 style/error-checking points; official total: 90.'

