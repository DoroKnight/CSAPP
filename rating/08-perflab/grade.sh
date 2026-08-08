#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$SCRIPT_DIR/../../proj/08-perflab" && pwd)}"
cd "$PROJECT_DIR"
make

output="$(./driver -g)"
printf '%s\n' "$output"
line="$(grep '^bestscores:' <<<"$output" | tail -n 1)"
IFS=: read -r _ rotate smooth _ <<<"$line"
rotate="${rotate:-0}"
smooth="${smooth:-0}"

awk -v r="$rotate" -v s="$smooth" 'BEGIN {
  rp=50*r/3.1; if (rp>50) rp=50
  sp=50*s/15.2; if (sp>50) sp=50
  printf "\nLocal self-study score: %.1f/100 (rotate %.1f/50, smooth %.1f/50)\n", rp+sp,rp,sp
  print "The official handout leaves full-credit thresholds site-specific; this rubric uses its optimized-reference means (3.1 and 15.2)."
}'

