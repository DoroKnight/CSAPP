#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$SCRIPT_DIR/../../proj/10-malloclab" && pwd)}"
cd "$PROJECT_DIR"
make

output="$(./mdriver -a -v -t ./traces)"
printf '%s\n' "$output"
correct="$(awk -F: '/^correct:/{print $2}' <<<"$output" | tail -n 1)"
perfidx="$(awk -F: '/^perfidx:/{print $2}' <<<"$output" | tail -n 1)"
correct="${correct:-0}"
perfidx="${perfidx:-0}"

awk -v c="$correct" -v p="$perfidx" 'BEGIN {
  cp=20*c/11; pp=35*p/100
  printf "\nAutomated score: %.1f/55 (correctness %.1f/20, performance %.1f/35)\n", cp+pp,cp,pp
  print "Manual review: 10 style/heap-checker points; official total: 65."
}'

