---
title: RootFS
since: 202508
---

## Docker rootfs

```
FROM scratch
LABEL \
    org.opencontainers.image.title="Buildroot Base Image" \
    org.opencontainers.image.vendor="Buildroot 2025.02" \
    org.opencontainers.image.licenses="Apache" \
    org.opencontainers.image.created="2025-08-01" \
    maintainer="slackman@disroot.org"

ADD rootfs.tar  /

CMD ["/bin/sh"]
```

问题：还是不能运行动态库
```
docker build -t root .
docker run -it --rm root

 echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

## 安装 buildroot

```
整体而言，从零制作一个工具链，对嵌入式的知识掌握还是需要深入的掌握，
另外，工具链对整个系统代码的稳定性有着极大的影响，所以直接用自动制作的工具链，一定要经过严格的压力测试，否则容易出现各种隐患。

因而，采用第三方制作好的，有专门公司维护的工具链，应该是一个更为有效的开发方式。
```

参考 Dockerfile
```
ENV DEBIAN_FRONTEND=noninteractive \
    FORCE_UNSAFE_CONFIGURE=1 \
    TZ=Asia/Shanghai \
    SDK=buildroot-2025.02
    
RUN apt-get update && apt-get install -y --no-install-recommends tzdata language-pack-en \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  \
    && echo $TZ > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

# Install base-devel
RUN apt-get install -y \
    build-essential less wget curl file \
    vim git zip unzip rsync cpio bc \
    dialog ncurses-base ncurses-bin libncurses5-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ARG CHECKSUM=f9444c2e3054e0b3d0f555ab8130520bd08cdb95196233672b52b9569d14c97f 

WORKDIR /build
ADD --checksum=sha256:${CHECKSUM} https://buildroot.org/downloads/${SDK}.tar.gz .

RUN tar -xf ${SDK}.tar.gz && cd ${SDK} \
    && make defconfig \
    && make source
```


## 默认 Buildin toolchain (成功)

 不能运行hello, 没有ldd
```
root@ubuntu22:/mnt/buildroot-2025.02# ls output/
build  host  images  staging  target
root@ubuntu22:/mnt/buildroot-2025.02# du -sh output/
6.7G    output/

# ls -lh images/
-rw-r--r-- 1 root root 5.1M  8月  1 15:09 rootfs.tar

# target/bin  target/sbin
usr/bin
usr/sbin
都是busybox链接


lib/libc.so.6
lib/libm.so.6

etc/os-release
etc/hostname
etc/fstab
etc/inittab
etc/init.d/rcS
```


## 使用 Ubuntu toolchain (报错)

```
External toolchain / Custom Toolchain / Pre-Install Toolchain
x86_64-linux-gnu-gcc
PREFIX: x86_64-linux-gnu 
External toolchain library: glibc

gcc 11
kernel 5.15
enable: C++ Support
enable: OpenMP Support
disable: RPC
```

## 使用 3rd toolchain (成功)

https://toolchains.bootlin.com/

x86-64--musl--stable-2024.02-1.tar.bz2  不能运行hello, 没有ldd
```
toolchain path: /mnt/musl-stable

x86_64-linux-gcc
PREFIX: x86_64-linux

gcc 12	
kernel 4.19
enable: C++ Support
enable: OpenMP Support
enable: Fortran Support
```

x86-64--glibc--stable-2024.05-1.tar.xz  可以运行hello，有/usr/bin/ldd
```
toolchain path: /mnt/glibc-stable

x86_64-linux-gcc
PREFIX: x86_64-linux

gcc 13	
kernel 4.19
enable: C++ Support
enable: OpenMP Support
disable: Fortan support

disable: RPC Support
ERROR disable BR2_TOOLCHAIN_EXTERNAL_INET_RPC

======
# ls -lh /
lib64 -> lib

# ls lib
ld-linux-x86-64.so.2  libc.so.6             libmvec.so.1          libpthread.so.0
libanl.so.1           libdl.so.2            libnsl.so.1           libresolv.so.2
libatomic.so.1        libgcc_s.so.1         libnss_dns.so.2       librt.so.1
libatomic.so.1.2.0    libm.so.6             libnss_files.so.2     libutil.so.1

# ldd hello
        linux-vdso.so.1 (0x00007ffc54532000)
        libc.so.6 => /lib64/libc.so.6 (0x000078af56817000)
        /lib64/ld-linux-x86-64.so.2 (0x000078af569fd000)
```