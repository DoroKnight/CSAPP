# CS:APP self-study grading scripts

Run these scripts inside **WSL2 Ubuntu**, not PowerShell or Git Bash. The supplied
Bomb/Attack/Buffer binaries are Linux ELF executables, and several other labs rely
on Linux process, signal, Valgrind, and socket behavior.

General usage:

```bash
cd /mnt/d/CSAPP
bash rating/01-datalab/grade.sh
```

Scripts locate their matching project through a relative path. Set `PROJECT_DIR`
to grade a copy elsewhere:

```bash
PROJECT_DIR="$HOME/csapp/datalab" bash rating/01-datalab/grade.sh
```

Input-based labs:

- Bomb Lab: `grade.sh answers.txt` where the file has one answer per line.
- Attack Lab: `grade.sh EXPLOIT_DIR`; expected files are `phase1.txt` through
  `phase5.txt`, in the official `hex2raw` text format.
- Buffer Lab: `grade.sh USERID EXPLOIT_DIR`; expected files are `smoke.txt`,
  `fizz.txt`, `bang.txt`, `boom.txt`, and `nitro.txt`.

The scripts report automated points separately from manual style/documentation
points. They do not contain or download solutions.

