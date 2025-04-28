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
$ make -j8
编译结果 arch/x86/boot/bzImage
```


## Busybox & initrd

<https://www.busybox.net/downloads/busybox-1.36.1.tar.bz2>
```
方式1：执行 make menuconfig 选择 Build Static Binary
方式2：执行 make defconfig 修改 .config文件
CONFIG_STATIC=y

$ make -j8
编译结果 当前目录 busybox二进制文件
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


