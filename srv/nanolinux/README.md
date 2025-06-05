=========== 方案1：freebsd pkg 

pkg 只能管理第三方软件包，并不能起到升级系统，获取安全更新的作用。这是因为 FreeBSD 项目是把内核与用户空间作为一个整体来进行维护的，而不是像 Linux 那样 linus torvalds 负责维护内核，各个发行版的人负责维护 GNU 工具（他们这些软件实际上被设计为单个软件包，因此可以用包管理器更新与升级系统）。

usr.sbin/pkg
LIBADD= archive fetch ucl crypto ssl util md

pkg search vim

pkg info
pkg info xxx
pkg info -l xxx // pkg list xxx

pkg install python
pkg remove  python
pkg autoremove

pkg fetch xxx

=========== 方案2： go pkg  （好像不能离线安装)
pkg.go.dev 
https://github.com/golang/pkgsite

wget https://mirrors.aliyun.com/golang/go1.23.5.linux-amd64.tar.gz
$> export PATH=/usr/local/go/bin:$PATH
$> go env

源码目录结构，可以用
└── $GOPATH
    └── src
        └── github.com
            └── gopherguides
                └── greet


A package is a collection of source files in the same directory that are compiled together.
A module is a collection of related Go packages that are released together. 

在Python中，有 模块(module) 和 包(package) 的概念
包是一个包含多个模块的目录，其中有个__init__.py 文件

/// Tiny最简系统
kernel + busybox (extract) + pkg

/// Nano
kernerl + busybox + pkg
 + toolchain.fs 
 + root.fs
 + bash


## Step1: Download source

cd download
wget -i filelist.wget
md5sum -c filelist.md5
sha256sum -c filelist.sha256


## Step2: Install Host Deps

pacman -S base-devel
pacman -S xxx yyy 



## Step3: Make toolchain.fs

makepkg toolchain.PKGBUILD

cd toolchain
make
make package ;; output zip,tar

/usr/local


## Step4: Make rootfs (root.fs)

makepkg base
makepkg base-devel
makepkg linux
makepkg linux-firmware


nano vim nvim less wget zip unzip zstd

/usr

