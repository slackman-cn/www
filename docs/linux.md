---
title: 'Linux'
since: 202412
---

## Toolchain

* GCC compiler, Binutils, and Glibc.

Basic System:

* Linux kernel
* Coreutils (basic file, shell, and text utilities)
* Bash shell
* GCC (GNU Compiler Collection)
* Binutils (binary tools like the assembler and linker)


## Linux From Scratch

1. __Source Code__  
In Linux From Scratch, you’ll compile everything from source code. This means you’ll be downloading raw code files and compiling them into binaries that your system can run.     
Understanding how to use compilers like GCC (GNU Compiler Collection) will be essential.

2. __Toolchain__  
A toolchain is a collection of programming tools used to develop a software project.   
In LFS, you’ll be building a temporary toolchain (consisting of compilers, linkers, and libraries) that will be used to compile the rest of the system.

3. __Bootloader__  
The bootloader is the first software that runs when your computer starts up.   
In LFS, you’ll need to install and configure a bootloader (like GRUB) to ensure your system can boot into the operating system you’ve built.

4. __Kernel__  
The Linux kernel is the core of the operating system, managing hardware resources and enabling communication between hardware and software.   
In LFS, you’ll download and compile the kernel yourself.

5. __File Systems__  
LFS requires a solid understanding of Linux file systems, such as ext4. You’ll need to format partitions, create a root file system, and set up the necessary directories for your system.



# About Links

<https://mirrors.ustc.edu.cn/lfs/lfs-packages/>

<https://batocera.org/>  <https://github.com/batocera-linux/>

<https://www.siberoloji.com/linux-from-scratch-lfs-for-beginners-a-comprehensive-guide-to-building-your-own-linux-distribution/>