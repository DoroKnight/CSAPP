<div align="center">

# sim 编译使用指南
</div>

---

本文档主要是对官方教程中的 README 的概括和补充，现在最新版的 gcc 和 GNU Make 在编译这些模拟器的时候并不是很方便，这里记录一下我踩过的坑

---

## 一、文档翻译
像我一样英语不好的可以直接看同目录下的 [README_translate.txt](./README_translate.txt)，这样能更快的理解（AI 太好用了你知道吗）

---

## 二、问题背景
CSAPP 在第四章的序言中就介绍了，他们提供了：
- Y86-64 的汇编器
- 运行 Y86-64 程序的模拟器
- 针对两个顺序处理器设计和一个流水线化处理器设计的模拟器
  
他们提供的文件资源正是本文件夹中的所有东西，源文件在上一目录下的 `tar` 文件中，也可以[点这里](../tar/sim.tar)来直接跳转到对应位置来直接下载，当然[官网](https://csapp.cs.cmu.edu/3e/students.html)肯定有.

本文件夹中包含的 Y86-64 的 sim 工具包含：
工具        功能
`yas`       Y86-64 汇编器
`yis`       Y86-64 ISA模拟器
`hcl2c`     将 HCL 转换成 C
`hcl2v`     将 HCL 转换成 Verilog
`ssim`      SEQ 处理器模拟器
`ssim+`     SEQ+ 处理器模拟器
`psim`      PIPE 流水线处理器模拟器

这一整套代码面向较早版本的 GCC、glibc 和 Tcl/Tk。现代 WSL2 Ubuntu 使用的是：

- GCC 10 或更高的版本
- glibc 2.27 或更高版本
- Tcl/Tk 8.6
- 新版 GNU Make
- Multiarch 多架构库目录

因此，原生的 Makefile 中针对 Tcl/Tk、旧版 C 全局变量等的代码在现代环境会出现**兼容性错误**。

---

## 三、安装依赖
根据原版 README 的设计，我们可以采用两种编译方式：一种是**使用 GUI 的可视化版本**，另一种是**全文本形式的 TTK 版本**，优缺点在 README 或 README_translate 中都有介绍，这里不做赘述。

### 3.1 构建 GUI 版本的 完整依赖
在 WSL2 Ubuntu 中执行：
```bash
sudo apt update
# sudo apt upgrade (可选)

sudo apt install -y \
    build-essential \
    flex \
    libfl-dev \
    bison \
    tcl \
    tk \
    tcl-dev \
    pkg-config
```

注意：部分包之间有依赖关系，比如 `tk-dev` 会依赖 `tcl-dev`、 `tk` 依赖版本化的 `tk8.6-dev`，**不要出现呢版本不对应**。

### 3.2 构建 TTY 版本的最小依赖
该版本不需要 Tcl/Tk 界面，因此不需要：
```
tcl
tk
tcl-dev
tk-dev
pkg-config
```

最终的安装命令为：
```bash
sudo apt update
# sudo apt upgrade (可选)

sudo apt install -y \
    build-essential \
    flex \
    libfl-dev \
    bison
```
---

## 四、各依赖项的用途（可跳过）
### 4.1 `build-essential`
`build-essential` 是 Ubuntu 官方提供的元包，本身不是编译器，但是里面有一下的基础开发工具：
- gcc：GNU C Compiler
- g++：GNU C++ Compiler
- make：构建任务调度工具
- libc6-dev：glibc 开发头文件和链接文件
- dpkg-dev：Ubuntu 软件包构建工具

本项目中使用：
```
gcc
make
libc6-dev
```

### 4.2 `flex`
Flex 是**词法分析器生成器**，读取 `.lex` 或 `.l` **规则文件**，默认生成 `lex.yy.c`，内部包含**词法扫描函数**：
```c
int yylex(void);
```
### 4.3 `libfl-dev`

CSAPP 在链接 yas 时使用：
```
-lfl
```
-lfl 表示让链接器查找：
```
libfl.so
```
libfl-dev 主要提供：
```
/usr/include/FlexLexer.h
/usr/lib/x86_64-linux-gnu/libfl.so
/usr/lib/x86_64-linux-gnu/libfl.a
/usr/lib/x86_64-linux-gnu/pkgconfig/libfl.pc
```
其中：

- libfl.so：Flex 运行支持库的动态链接入口；

- libfl.a：静态链接版本；

- FlexLexer.h：C++ Flex 扫描器接口；

- libfl.pc：供 pkg-config 使用的元数据。

Flex 生成的扫描器如果没有自行实现 yywrap()，通常需要链接 -lfl 获得默认实现。[Flex Generated Scanner](https://westes.github.io/flex/manual/Introduction.html)

为了保证构建可重复，建议显式安装：
```
sudo apt install -y libfl-dev
```

### 4.4 `bison`
Bison 是**语法分析器生成器**，兼容传统 Yacc。

它将上下文无关文法 `.y` 文件转换为 C 语言语法分析器。

在 CSAPP 中：
```
hcl.y
   ↓ bison -d
hcl.tab.c
hcl.tab.h
```
实际命令：
```
bison -d hcl.y
```
其中：

- hcl.tab.c：生成的语法分析器实现；

- hcl.tab.h：Token、类型和接口声明；

- -d：要求同时生成头文件。

GNU Bison 官方说明：[Bison Manual](https://www.gnu.org/software/bison/manual/bison.html)

随后，hcl2c 由以下文件构建：
```
node.c
lex.yy.c
hcl.tab.c
outgen.c
```
对应命令：
```
gcc node.c lex.yy.c hcl.tab.c outgen.c -o hcl2c
```

### 4.5 Tcl 运行时
Tcl 即 Tool Command Language，是一种嵌入式脚本语言。

Ubuntu 的：
```
tcl
```
是默认版本元包，通常会安装：
```
tcl8.6
libtcl8.6
```
主要运行时文件包括：
```
/usr/bin/tclsh
/usr/bin/tclsh8.6
/usr/lib/x86_64-linux-gnu/libtcl8.6.so
/usr/lib/x86_64-linux-gnu/libtcl8.6.so.0
/usr/share/tcltk/tcl8.6/
```
验证 Tcl 版本：
```
tclsh <<< 'puts [info patchlevel]'
```
可能输出：
```
8.6.14
```
Ubuntu Tcl 包信息：[tcl8.6](https://packages.ubuntu.com/tcl8.6)

### 4.6 Tk 运行时
Tk 是建立在 Tcl 之上的 GUI toolkit（图形界面工具包）。

Ubuntu 的：
```
tk
```
通常会安装：
```
tk8.6
libtk8.6
```
主要运行时文件包括：
```
/usr/bin/wish
/usr/bin/wish8.6
/usr/lib/x86_64-linux-gnu/libtk8.6.so
/usr/lib/x86_64-linux-gnu/libtk8.6.so.0
/usr/share/tcltk/tk8.6/
```
Tk 依赖 X11/Wayland 图形显示环境。在 WSL2 中通常由 WSLg 提供图形应用支持。

可以运行：
```
wish
```
如果弹出 Tk 窗口，说明图形运行环境正常。

Microsoft 官方说明 WSL2 支持通过 WSLg 运行 X11 和 Wayland 图形程序：在 WSL 中运行 Linux GUI 应用

如果 GUI 无法启动，可在 Windows PowerShell 中执行：
```
wsl --update
wsl --shutdown
```

### 4.7 `tcl-dev`
`tcl-dev` 是默认 Tcl 开发包，进一步依赖版本化的：
```
tcl8.6-dev
```
它提供编译 Tcl 程序需要的头文件、链接文件和配置元数据。

关键文件包括：
```
/usr/include/tcl
/usr/include/tcl8.6/tcl.h
/usr/include/tcl8.6/tclDecls.h

/usr/lib/x86_64-linux-gnu/libtcl.so
/usr/lib/x86_64-linux-gnu/libtcl.a
/usr/lib/x86_64-linux-gnu/libtclstub.a

/usr/lib/x86_64-linux-gnu/pkgconfig/tcl.pc
/usr/lib/x86_64-linux-gnu/tclConfig.sh
```
Ubuntu 官方文件列表：[tcl-dev 文件列表](https://packages.ubuntu.com/noble/all/tcl-dev/filelist)

其中最重要的是：
```
#include <tcl.h>
```
以及链接参数：
```
-ltcl
```
或者版本化链接：
```
-ltcl8.6
```

### 4.8 `tk-dev`
`tk-dev` 是默认 Tk 开发包，并依赖：
```
tcl-dev
tk
tk8.6-dev
```
主要文件包括：
```
/usr/include/tcl8.6/tk.h
/usr/include/tcl8.6/tkDecls.h

/usr/lib/x86_64-linux-gnu/libtk.so
/usr/lib/x86_64-linux-gnu/libtk.a
/usr/lib/x86_64-linux-gnu/libtkstub.a

/usr/lib/x86_64-linux-gnu/pkgconfig/tk.pc
/usr/lib/x86_64-linux-gnu/tkConfig.sh
```
Ubuntu 官方包说明：[tk-dev](https://packages.ubuntu.com/en/noble/tk-dev)、[tk8.6-dev](https://packages.ubuntu.com/en/noble/tk8.6-dev)

CSAPP 的 psim.c 和 ssim.c 在启用 GUI 时包含：
```
#include <tk.h>
```
由于 `tk.h` 又包含 Tcl 接口，因此编译 Tk 程序时通常同时需要 Tcl 和 Tk 的头文件与库。

### 4.9 `pkg-config`
`pkg-config` 用于读取库提供的 `.pc` 配置文件，并自动生成编译参数。

Ubuntu 新版本中的 pkg-config 可能是指向 pkgconf 实现的过渡包，但命令仍然是：
```
pkg-config
```
查看 Tcl/Tk 版本：
```
pkg-config --modversion tcl
pkg-config --modversion tk
```
查看头文件参数：
```
pkg-config --cflags tcl tk
```
本次环境输出：
```
-I/usr/include/tcl8.6
```
查看链接参数：
```
pkg-config --libs tcl tk
```
本次环境输出：
```
-ltk8.6 -ltkstub8.6 -ltcl8.6 -ltclstub8.6
```
pkg-config 的优势是避免在 Makefile 中写死：
```
/usr/include/tcl8.5
```
当 Ubuntu 的 Tcl/Tk 版本或 CPU 架构发生变化时，.pc 文件会返回当前系统对应的参数。

Ubuntu 包信息：[pkg-config](https://packages.ubuntu.com/pkg-config)

## 五、最终编译指令
第一步，进入项目：
```bash
cd YOUR_PROJ_PATH
```

第二步，清理：
```bash
make clean
```

第三步，编译：
- GUI 可视化版本
    ```bash
    make -j"$(nproc)" \
    CC="gcc -fcommon -DUSE_INTERP_RESULT" \
    GUIMODE="-DHAS_GUI" \
    TKINC="$(pkg-config --cflags tcl tk)" \
    TKLIBS="$(pkg-config --libs tcl tk) -Wl,--defsym=matherr=0"
    ```
    单行版本:
    ```bash
    make -j"$(nproc)" CC="gcc -fcommon -DUSE_INTERP_RESULT" GUIMODE="-DHAS_GUI" TKINC="$(pkg-config --cflags tcl tk)" TKLIBS="$(pkg-config --libs tcl tk) -Wl,--defsym=matherr=0"
    ```

- TKK 自动化版本
```bash
make -j"$(nproc)" \
  CC="gcc -fcommon" \
  GUIMODE="" \
  TKINC="" \
  TKLIBS=""
```
单行版本：
```bash
make -j"$(nproc)" CC="gcc -fcommon" GUIMODE="" TKINC="" TKLIBS=""
```