---
title: Ubuntu
since: 202412
---


## rootfs

```
ubuntu-base-22.04-base-amd64.tar.gz
https://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/
https://mirrors.ustc.edu.cn/ubuntu-cdimage/ubuntu-base/releases/

AnolisOS8.9-base-amd64-20240425.tar.xz
https://cr-images-pub.oss-cn-hangzhou.aliyuncs.com/root/base/
```


## debootstrap

```
sudo apt install debootstrap
sudo debootstrap --help
ls -lh /usr/share/debootstrap/scripts  都是链接

debootstrap --arch $ARCH $RELEASE  $DIR $MIRROR
debootstrap --arch amd64 buster /mnt/rootfs-minbase http://mirrors.163.com/debian/
debootstrap --include linux-image-amd64,locales,grub-efi-amd64,vim,btrfs-progs,sudo --arch amd64 sid /mnt/rootfs http://mirrors.163.com/debian/

sudo debootstrap --arch=mips buster /mnt/rootfs
sudo debootstrap --variant=minbase --no-check-gpg --arch=amd64 
sudo debootstrap --components main,universe,multiverse,restricted --variant minbase \
 --include libc6,kysec-utils --exclude bash --no-check-gpg

$ cd /mnt/rootfs
$ sudo tar -czf /tmp/debian-sid-rootfs.tar.xz  .
$ sudo tar -xf rootfs.tar.xz -C <exampledir>
```


## chroot (QEMU)

https://akhileshmoghe.github.io/_post/linux/debian_minimal_rootfs#remove-support-files-from-rootfs
https://www.ddupan.top/posts/chroot-to-a-different-arch-in-linux/
```
$ sudo apt install qemu-user-static
$ sudo apt install binfmt-support

sudo debootstrap --arch arm64 --foreign buster /mnt/buster-arm64 http://mirrors.163.com/debian/
sudo cp /usr/bin/qemu-aarch64-static buster-arm64/usr/bin/
sudo cp /etc/resolv.conf buster-arm64/etc/

$ sudo chroot /mnt/buster-arm64/
```