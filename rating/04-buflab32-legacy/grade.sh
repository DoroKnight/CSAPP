#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$SCRIPT_DIR/../../proj/04-buflab32-legacy" && pwd)}"
USERID="${1:-}"
EXPLOIT_DIR="${2:-$SCRIPT_DIR}"

if [[ -z "$USERID" ]]; then
  echo "Usage: $0 USERID [EXPLOIT_DIR]" >&2
  exit 2
fi

cd "$PROJECT_DIR"
score=0

grade_level() {
  local label="$1" file="$2" weight="$3" nitro="$4"
  if [[ ! -f "$file" ]]; then
    printf '%-10s %2d/%2d (missing %s)\n' "$label" 0 "$weight" "$file"
    return
  fi

  local output
  if [[ "$nitro" == yes ]]; then
    output="$(timeout 10s ./hex2raw -n <"$file" | timeout 10s ./bufbomb -n -u "$USERID" 2>&1)"
  else
    output="$(timeout 10s ./hex2raw <"$file" | timeout 10s ./bufbomb -u "$USERID" 2>&1)"
  fi
  if grep -q 'VALID' <<<"$output"; then
    score=$((score + weight))
    printf '%-10s %2d/%2d\n' "$label" "$weight" "$weight"
  else
    printf '%-10s %2d/%2d\n' "$label" 0 "$weight"
    printf '%s\n' "$output" | tail -n 5
  fi
}

grade_level 'Candle'      "$EXPLOIT_DIR/smoke.txt" 10 no
grade_level 'Sparkler'    "$EXPLOIT_DIR/fizz.txt"  10 no
grade_level 'Firecracker' "$EXPLOIT_DIR/bang.txt"  15 no
grade_level 'Dynamite'    "$EXPLOIT_DIR/boom.txt"  20 no
grade_level 'Nitro'       "$EXPLOIT_DIR/nitro.txt" 10 yes
printf '\nBuffer Lab score: %d/65\n' "$score"

