#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$SCRIPT_DIR/../../proj/11-proxylab" && pwd)}"
cd "$PROJECT_DIR"

for cmd in gcc make curl python3; do
  command -v "$cmd" >/dev/null || { echo "Missing dependency: $cmd" >&2; exit 2; }
done

make
# The 2019 handout uses an obsolete /usr/bin/python shebang for a script
# whose source is Python 3 compatible. Patch the invocation in a stream so
# the preserved project files stay byte-for-byte unchanged.
sed 's#^\./nop-server.py #python3 ./nop-server.py #' ./driver.sh | bash
echo 'Official total: 70 (40 basic + 15 concurrency + 15 cache).'
