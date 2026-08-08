#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$SCRIPT_DIR/../../proj/03-attacklab" && pwd)}"
EXPLOIT_DIR="${1:-$SCRIPT_DIR}"

cd "$PROJECT_DIR"
score=0

grade_phase() {
  local label="$1" file="$2" target="$3" weight="$4"
  if [[ ! -f "$file" ]]; then
    printf '%-10s %2d/%2d (missing %s)\n' "$label" 0 "$weight" "$file"
    return
  fi

  local output
  output="$(timeout 10s ./hex2raw <"$file" | timeout 10s "$target" -q 2>&1)"
  if grep -Eq 'PASS|Valid solution' <<<"$output"; then
    score=$((score + weight))
    printf '%-10s %2d/%2d\n' "$label" "$weight" "$weight"
  else
    printf '%-10s %2d/%2d\n' "$label" 0 "$weight"
    printf '%s\n' "$output" | tail -n 5
  fi
}

grade_phase 'Phase 1' "$EXPLOIT_DIR/phase1.txt" ./ctarget 10
grade_phase 'Phase 2' "$EXPLOIT_DIR/phase2.txt" ./ctarget 25
grade_phase 'Phase 3' "$EXPLOIT_DIR/phase3.txt" ./ctarget 25
grade_phase 'Phase 4' "$EXPLOIT_DIR/phase4.txt" ./rtarget 35
grade_phase 'Phase 5' "$EXPLOIT_DIR/phase5.txt" ./rtarget 5
printf '\nAttack Lab score: %d/100\n' "$score"

