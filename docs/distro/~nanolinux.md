---
title: NanoLinux
since: 202505
---

FROM:  NanoPi R5S,  GNU nano editor, iPod nano 


## TMPFS

```
mkdir /root/build
mount -t tmpfs tmpfs /root/build -o size=6G,nr_inodes=10000000
```


## Kernel

<https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.165.tar.xz>
```
// sudo apt build-dep linux-image-amd64

sudo apt install bc binutils bison dwarves flex gcc git \
     gnupg2 gzip libelf-dev libncurses5-dev libssl-dev \
    make openssl pahole perl-base rsync tar xz-utils

$ make defconfig
$ make menuconfig
$ make -j8

编译结果 arch/x86/boot/bzImage
Linux kernel x86 boot executable bzImage, version 5.15.165 (root@4b44b9573558) #1 SMP Mon Apr 28 15:56:47 CST 2025
, RO-rootFS, swap_dev 0XA, Normal VGA
```

## toolchain

https://crosstool-ng.github.io/docs/toolchain-construction/

https://chschneider.eu/linux/tfs/

## makepkg

slackware && openwrt/toolchain
```
slackware64-current/source/a/pkgtools/scripts
slackware64-current/source/d/binutils

> Applications
> ApplicationImages
> Frameworks
> Library {shell, desktop, openssh}  pkglist;pkgmake
> Images
> User { config; local; }

引导Kernel
运行Kernel


proc
sys
dev/pts

mount -t sysfs sysfs /sys
mount -t proc proc /proc
mount -p devtmpfs udev /dev

mount -t proc /proc /mnt/rootfs/proc
mount -t sysfs /sys /mnt/rootfs/sys
mount -o bind /dev /mnt/rootfs/dev
mount -o bind /dev/pts /mnt/rootfs/dev/pts

etc
var
opt
tmp

------- Applications
busybox
google-chrome
vim
nano-editor
qtcreator

------- Frameworks  
(/usr/local/go;  /usr/local/node)
kernel
java
ruby
node
make -> gcc toolchain
toolchain (gnu)
python
lua
```

## NL Toolchain

FROM docker.io/alpine:3.11
```
======= 软件仓库
$ less /etc/apk/repositories
https://dl-cdn.alpinelinux.org/alpine/v3.21/main
https://dl-cdn.alpinelinux.org/alpine/v3.21/community

https://mirrors.ustc.edu.cn/alpine/v3.21/main
https://mirrors.ustc.edu.cn/alpine/v3.21/community

======= 软件
apk list  ; all package
apk stats ; installed package
apk update
apk search <name>
apk add <name>
apk del <name>

apk add neovim
alias vi='nvim'

====== 设置 locale
apk add musl-locales
locale -a

主机名
setup-hostname liveos

====== 设置 Date
apk add -U tzdata
ls /usr/share/zoneinfo/

方式1
setup-timezone Asia/Shanghai
方式2
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

```

## NL rootfs

<https://buildroot.org/downloads/buildroot-2025.02.tar.gz>

<https://mirrors.hust.edu.cn/docs/buildroot/>
```
sudo apt-get install build-essential ncurses-base ncurses-bin libncurses5-dev dialog

$ make menuconfig
$ make
下载源码 dl  ;; 也可以执行命令 make source
编译结果 output

Target options
        -> Target Architecture = ARM (little endian)
        -> Target Binary Format = ELF
        -> Target Architecture Variant = cortex-A7
        -> Target ABI = EABIhf
        -> Floating point strategy = NEON/VFPv4
        -> ARM instruction set = ARM

Toolchain
   -> Toolchain type = External toolchain
   -> Toolchain = Custom toolchain //选择用户的交叉编译器

System configuration
   -> System hostname = Embedfire_imx6ull //平台名字
   -> System banner = Welcome to embedfire i.mx6ull //欢迎语
   -> Init system = BusyBox //使用 busybox
```


## NL source

wget -i wget-list
```
docker pull quay.io/slackman/openwrt-src

sudo apt install gawk texinfo
readlink -f /bin/sh
$ sudo ln -sf bash /bin/sh
$ sudo ln -sf dash /bin/sh

git clone -b v24.10.0 git://192.168.1.1/git.openwrt.org/openwrt/openwrt.git --depth=1
touch feeds.conf
src-git packages git://192.168.1.1/git.openwrt.org/feed/packages.git

======= Step1: 
$ ./script/feeds/update  -a
create dir {feeds}
create dir {staging_dir/host/bin, tmp}
clone  {feeds/packages}
create {feeds/packages.index,  packages.targetindex}
	system("ln -sf $name.tmp/.packageinfo ./feeds/$name.index");
	system("ln -sf $name.tmp/.targetinfo ./feeds/$name.targetindex");


======= Step2: 
$ ./script/feeds/install -a
create link {feeds/base -> /root/openwrt/package}

```

## NL disk

```
sudo apt install qemu-utils
qemu-img create disk.img 20G

sudo fdisk -l disk.img
sudo fdisk disk.img

---- part1
o
n
p
/
+100M
a
---- part2
n
p
/
/
w
```

## NL rootfs

```
mount -t proc /proc /mnt/rootfs/proc
mount -t sysfs /sys /mnt/rootfs/sys
mount -o bind /dev /mnt/rootfs/dev
mount -o bind /dev/pts /mnt/rootfs/dev/pts

$ chroot /mnt/rootfs

umount  /mnt/rootfs/dev/pts
umount  /mnt/rootfs/dev
umount  /mnt/rootfs/proc
umount  /mnt/rootfs/sys
```

filesystem
```
$ man interfaces
$ man resolv.conf
$ man hostname
$ man hosts

export LC_ALL=en_US.UTF-8
apt-get install locales
dpkg-reconfigure locales

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo Asia/Shanghai > /etc/timezone

dbus-uuidgen > /etc/machine-id
apt-get autoremove -y
apt-get clean -y

tar -cvpf /tmp/system.tar --directory=/ \
  --exclude=proc --exclude=sys --exclude=dev --exclude=run \
   --exclude=boot .

-e "var/cache/apt/archives/*" \
-e "root/*" \
-e "root/.*" \
-e "tmp/*" \
-e "tmp/.*" \
-e "swapfile"
```


# About Links

<https://classpert.com/classpertx/courses/building-a-programming-language/cohort>

<https://mirrors.aliyun.com/lfs/lfs-packages/11.2>

<https://tldp.org/HOWTO/From-PowerUp-To-Bash-Prompt-HOWTO.html>