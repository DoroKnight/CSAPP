#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$SCRIPT_DIR/../../proj/05-archlab-y86-64" && pwd)}"
SIM="$PROJECT_DIR/sim"

echo '== Build Y86-64 tools =='
make -C "$SIM/misc" || exit 1

part_a=0
for spec in 'sum.ys:10' 'rsum.ys:10' 'copy.ys:10'; do
  file="${spec%%:*}"
  points="${spec##*:}"
  if [[ -f "$SIM/misc/$file" ]]; then
    (cd "$SIM/misc" && ./yas "$file")
    output="$(cd "$SIM/misc" && ./yis "${file%.ys}.yo")"
    if grep -Eqi '0x0*0?cba' <<<"$output"; then
      part_a=$((part_a + points))
      echo "$file: PASS ($points/$points)"
    else
      echo "$file: CHECK FAILED (0/$points)"
    fi
  else
    echo "$file: missing (0/$points)"
  fi
done
echo "Part A automated result: $part_a/30"

echo
echo '== Part B: SEQ iaddq regression tests =='
make -C "$SIM/seq" VERSION=full GUIMODE= TKLIBS= TKINC=
make -C "$SIM/y86-code" testssim
make -C "$SIM/ptest" SIM=../seq/ssim TFLAGS=-i
echo 'Part B itemized rubric: 25 automated test points + 10 manual description points.'

echo
echo '== Part C: PIPE correctness and performance =='
make -C "$SIM/pipe" VERSION=full GUIMODE= TKLIBS= TKINC=
(cd "$SIM/pipe" && ./correctness.pl)
(cd "$SIM/y86-code" && make testpsim)
(cd "$SIM/ptest" && make SIM=../pipe/psim)
(cd "$SIM/pipe" && ./correctness.pl -p)
(cd "$SIM/pipe" && ./benchmark.pl)
echo 'Part C: benchmark.pl reports performance out of 60; 40 implementation/header points are manual.'
echo 'Note: the official PDF says Part B is both 60 and 35 points; this script reports itemized raw results.'
