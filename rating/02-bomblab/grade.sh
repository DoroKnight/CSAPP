#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$SCRIPT_DIR/../../proj/02-bomblab" && pwd)}"
ANSWERS="${1:-}"

if [[ -z "$ANSWERS" || ! -f "$ANSWERS" ]]; then
  echo "Usage: $0 answers.txt" >&2
  exit 2
fi

cd "$PROJECT_DIR"
output="$(timeout 15s ./bomb "$ANSWERS" </dev/null 2>&1)"
status=$?
printf '%s\n' "$output"

score=0
checks=(
  "10|Phase 1 defused"
  "10|That's number 2"
  "10|Halfway there"
  "10|So you got that one"
  "15|Good work"
  "15|Congratulations"
)
for check in "${checks[@]}"; do
  weight="${check%%|*}"
  message="${check#*|}"
  if grep -Fq "$message" <<<"$output"; then
    score=$((score + weight))
  fi
done

printf '\nBomb Lab score: %d/70\n' "$score"
if (( status == 124 )); then
  echo "Warning: bomb timed out; check whether answers.txt has six lines." >&2
fi

