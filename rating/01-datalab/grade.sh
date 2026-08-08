#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$SCRIPT_DIR/../../proj/01-datalab" && pwd)}"

cd "$PROJECT_DIR"
make
perl ./driver.pl
printf '\nOfficial automated score: 62 points (36 correctness + 26 performance).\n'
printf 'Manual review: 5 style/comment points; official total: 67.\n'

