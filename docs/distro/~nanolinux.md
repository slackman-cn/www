---
title: NanoLinux
since: 202504
---

FROM:  NanoPi R5S,  GNU nano editor, iPod nano 


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

## NanoLinux Toolchain

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

## NanoLinux rootfs

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


## NanoLinux source

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

## NanoLinux disk

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

## NanoLinux rootfs

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


## Busybox & initrd

<https://www.busybox.net/downloads/busybox-1.36.1.tar.bz2>
```
// sudo apt build-dep busybox

sudo apt install build-essential libncurses5 libncurses5-dev

方式1：执行 make menuconfig 选择 Build Static Binary
方式2：执行 make defconfig 修改 .config文件
CONFIG_STATIC=y
$ make -j8

编译结果 ./busybox
ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, BuildID[sha1]=f4272eda9a1f20e170627b3f01499d5fa553e13e
, for GNU/Linux 3.2.0, stripped

安装使用
mkdir /root/afs/bin
./busybox --install /root/afs/bin
ls -i bin
```
 
initrd
```
mkdir -p initrd/{bin,sys,dev,proc}
cd initrd/bin && bash ./busybox_expat.sh
cd initrd && bash ./create.sh

测试启动
qemu-system-x86_64 --kernel ./bzImage --initrd ./initrd.img
```

Script
```
cp busybox-1.36.1/busybox initrd/bin/
=========== initrd/bin/busybox_expat.sh
for cmd in $(./busybox --list); do
   ln -s ./busybox ./$cmd
done

========== initrd/init
#!/bin/sh
mount -t sysfs sysfs /sys
mount -t proc proc /proc
mount -p devtmpfs udev /dev
sysctl -w kernel.printk="2 4 1 7"

clear
/bin/sh

========== initrd/create.sh
rm -rf ../initrd.img
find . | cpio -o -H newc > ../initrd.img
```



## Shell & ISO

man 2 <xx> // read,write,execve,fork,wait
```
#include <unistd.h>
#include <sys/wait.h>

int main()
{
    char cmd[255];
    for (;;) {
        write(1, "# ", 2);
        int count = read(0, cmd, 255);
        cmd[count-1] = 0;
        pid_t fork_result = fork();
        if (fork_result == 0) {
            execve(cmd, 0, 0);
            break;
        } else {
            siginfo_t info;
            waitid(P_ALL, 0, &info, WEXITED);
        }
    }
}
```

sudo apt install syslinux isolinux
```
gcc -static shell.c -o init
echo init | cpio -H newc -o > init.cpio

cd linux-v5.15
make isoimage FDARGS="initrd=/init.cpio" FDINITRD=~/pub/init.cpio

实际执行脚本
arch/x86/boot/genimage.sh
```



# About Links

<https://classpert.com/classpertx/courses/building-a-programming-language/cohort>

<https://mirrors.aliyun.com/lfs/lfs-packages/11.2>

<https://tldp.org/HOWTO/From-PowerUp-To-Bash-Prompt-HOWTO.html>