---
title: ArchLinux
since: 202412
---

## BIOS or EFI

/sys/firmware/efi exists means system uses UEFI
```
$ nano  /etc/pacman.d/mirrorlist
Server = http://mirrors.aliyun.com/archlinux/$repo/os/$arch

$ pacman -S efibootmgr
$ efibootmgr
EFI variables are not supported on this system.
```

## MBR or GPT

```
$ fdisk -l 查看gpt还是dos
$ fdisk /dev/sda
输入m，输入o修改dos, 输入g修改gpt, 输入a修改boot标签
输入d 删除所有分区
  Create a new label
   g   create a new empty GPT partition table
   G   create a new empty SGI (IRIX) partition table
   o   create a new empty MBR (DOS) partition table
   s   create a new empty Sun partition table

$ fdisk /dev/sda  添加两个p分区，sda1=300M, 设置boot
$ mkfs.fat -F 32 /dev/sda1
$ mkfs.ext4 /dev/sda2

====== 其他分区工具 
cfdisk  /dev/sda  两个分区 sda1 EFI, sda2 linux filesystem
```

## archlinux-2025.05.01

Step1: RootFS
```
mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot

修改宿主机 /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware
pacstrap /mnt networkmanager vim nano sudo zsh bash bash-completion

genfstab -U /mnt >> /mnt/etc/fstab
```

Step2: chroot

> umount -R /mnt  ;; before reboot
```
arch-chroot /mnt
vim /etc/hostname
vim /etc/hosts
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

vim /etc/locale.gen
locale-gen
# 这里不建议将 en_US.UTF-8 改为zh_CN.UTF-8 ，这样会导致终端乱码！ 
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "LANG=en_US.UTF-8" >> /etc/profile
```

Step3: grub
```
passwd root
pacman -S grub

====== msdos
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

====== gpt
pacman -S efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --recheck
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB 
```

## Reboot

```
$ systemctl enable NetworkManager 
也可以手动激活网络
nmtui  激活connection  或者 nmcli dev up ens33

$ pacman -S openssh 
$ systemctl enable sshd
修改 sshd_config  {PermitRootLogin yes; PasswordAuthentication yes}

pacman -S less wget  zip unzip
pacman -S arch-install-scripts  // 有 arch-install, pacstrap
pacman -S helix nano
ln -s /usr/bin/helix  /usr/bin/vi
> helix相当于一个已经配置完整的vim, space查看功能
> nano复制比较方便
```


## Desktop

```
pacman -S xorg  # Install 330M  包含了 xorg-server, 等于--needed安装包数量
pacman -S --needed qemu-desktop
pacman -S firefox vlc 
```

gnome
```
// Install 1.7G  包含了gdm（可以直接root登录）
// pacman -S gnome 

# Install 890M  足够使用：桌面环境(文件管理器), 终端, 文件编辑器，系统设置
pacman -S gnome-desktop gnome-terminal gnome-text-editor gnome-system-monitor gnome-control-center gdm

systemctl enable gdm
pacman -S gnome-disk-utility  不是必须
```

lxqt
```
pacman -S lxqt  // groups
pacman -S breeze-icons   // icon theme (e.g. breeze-icons or oxygen-icons).

# create user
useradd -m -g users -s /bin/bash slackman
pacman -S sddm
systemctl enable sddm

允许root登录
$ vim /etc/sddm.conf
MinimumUid=0

pacman -S deepin-community-wallpapers
/usr/share/wallpapers/deepin
```