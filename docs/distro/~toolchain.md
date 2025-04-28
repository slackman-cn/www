---
title: Toolchain
since: 202504
---


## Build System

• Clang 5.0
• Apple Clang 10.0
• GCC 7.4
• Visual Studio 2019 16.8

```
Toolchain 包括: gcc, libc库, linux内核头文件, binutils, 其他构建打包工具(m4,gmp,mpc)
• 方式1：从0开始制作 make toolchain
• 方式2：外部

[GCC]  https://wiki.ubuntu.com/ToolChain#GCC
[Binutils] https://wiki.ubuntu.com/ToolChain#Binutils
[Glibc] https://wiki.ubuntu.com/ToolChain#Glibc
[kernel] https://wiki.ubuntu.com/ToolChain#kernel_headers_for_user_space_packages
```


![LICENSE](../img/license.png)


## 编译工具 GCC 和 CMake 

```
======= ubuntu 安装
apt install build-essential
apt install cmake ninja-build

======= RHEL 安装
sudo dnf groupinstall 'Development Tools'
sudo dnf install make
sudo dnf install cmake ninja-build

======== 使用方式 gcc hello.c -o hello
#include <stdio.h>

int main() {
  printf("hello world\n");
  return 0;
}

========= 使用方式 CMakeLists.txt
mkdir build && cd build
cmake -G Ninja ..

ninja 
或cmake --build .
```

GCC Source
```
gcc_version=7.4.0
% wget https://ftp.gnu.org/gnu/gcc/gcc-${gcc_version}/gcc-${gcc_version}.tar.bz2
% wget https://ftp.gnu.org/gnu/gcc/gcc-${gcc_version}/gcc-${gcc_version}.tar.bz2.sig
% wget https://ftp.gnu.org/gnu/gnu-keyring.gpg
% signature_invalid=`gpg --verify --no-default-keyring --keyring ./gnu-keyring.gpg gcc-${gcc_version}.tar.bz2.sig`
% if [ $signature_invalid ]; then echo "Invalid signature" ; exit 1 ; fi
% tar -xvjf gcc-${gcc_version}.tar.bz2
% cd gcc-${gcc_version}
% ./contrib/download_prerequisites
% cd ..
% mkdir gcc-${gcc_version}-build
% cd gcc-${gcc_version}-build
% $PWD/../gcc-${gcc_version}/configure --prefix=$HOME/toolchains --enable-languages=c,c++
% make -j$(nproc)
% make install
```

GCC
```
mkdir build
% cd build
% CC=$HOME/toolchains/bin/gcc CXX=$HOME/toolchains/bin/g++ \
  cmake .. -DCMAKE_CXX_LINK_FLAGS="-Wl,-rpath,$HOME/toolchains/lib64 -L$HOME/toolchains/lib64"
```

CMake Source
```
sudo apt-get install libssl-dev

# https://github.com/Kitware/CMake/releases/download/v3.19.0-rc3/
tar -zxvf cmake-3.19.0-rc3.tar.gz
cd cmake-3.19.0-rc3
./bootstrap --prefix=/opt/cmake
make all install
```


## 编译工具 Clang (LLVM)

LLVM是一个包括了很多模块的编译器框架。

- clang是LLVM的前端: 用于编译C、C++和Objective-C等语言, 输出中间代码LLVM IR，再交给后端生成本机代码

- lldb 是一个开源的调试器

- clangd是一个基于Clang编译器的语言服务器: 用于提供C/C++语言的代码补全、语义分析和代码导航等功能
```
======= ubuntu22 安装
sudo apt install clang

root@ubuntu22:~# /usr/bin/clang --version
root@ubuntu22:~# /usr/bin/clang-14 --version
Ubuntu clang version 14.0.0-1ubuntu1.1
Target: x86_64-pc-linux-gnu
Thread model: posix
InstalledDir: /usr/bin


======== 官方仓库 (可以指定版本)
wget https://apt.llvm.org/llvm.sh
sudo ./llvm.sh 17   ## 格式 sudo ./llvm.sh <版本号>

软件源
deb http://apt.llvm.org/jammy/  llvm-toolchain-jammy-18 main
deb-src http://apt.llvm.org/jammy/  llvm-toolchain-jammy-18 main

会安装这几个软件
apt install clang-18 lldb-18 lld-18 clangd-18

root@ubuntu22:~# /usr/bin/clang-18 --version
Ubuntu clang version 18.1.8 (++20240731024944+3b5b5c1ec4a3-1~exp1~20240731145000.144)
Target: x86_64-pc-linux-gnu
Thread model: posix
InstalledDir: /usr/bin


======== 使用方式 clang hello.c -o hello
#include <stdio.h>

int main() {
  printf("hello world\n");
  return 0;
}
```

Source
```
# https://lldb.llvm.org/resources/build.html
# https://llvm.org/docs/GettingStarted.html#getting-started-with-llvm
# https://llvm.org/docs/CMake.html

yum install libedit-devel libxml2-devel ncurses-devel python-devel swig
https://github.com/llvm/llvm-project.git
https://mirrors.tuna.tsinghua.edu.cn/git/llvm-project.git

============== 方法1，没有bin/clang
cd llvm-project
cmake -S llvm -B build -G Ninja -DCMAKE_BUILD_TYPE=Release

cd build
ninja
或 ninja -C build check-llvm


============ 方法2, 有bin/clang
cd $HOME/build
$ cmake -G Ninja -DLLVM_ENABLE_PROJECTS="clang;lldb" [<cmake options>] path/to/llvm-project/llvm

cmake -G Ninja -DLLVM_ENABLE_PROJECTS="clang;lldb" \
   -DCMAKE_BUILD_TYPE=Release \
   -DCMAKE_INSTALL_PREFIX=/install/path \
   $HOME/llvm-project/llvm

```

Document
```
$ sudo apt-get install doxygen graphviz swig
$ pip3 install -r /path/to/llvm-project/llvm/docs/requirements.txt

$ ninja docs-lldb-html
$ ninja docs-lldb-man
$ ninja lldb-cpp-doc
```