---
title: ArchLinux
since: 202412
---

## archlinux-2025.04.01

archlinux-2025.04.01-x86_64.iso

Step1: Disk
```
$ fdisk -l 查看gpt还是dos
$ fdisk /dev/sda  添加两个p分区，sda1=300M, 设置boot
输入m，输入o修改dos, 输入g修改gpt, 输入a修改boot标签

mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2

====== 其他分区工具 
cfdisk  /dev/sda  两个分区 sda1 EFI, sda2 linux filesystem
```

Step2: RootFS
```
mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot

修改宿主机 /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware
pacstrap /mnt networkmanager vim sudo bash bash-completion

genfstab -U /mnt >> /mnt/etc/fstab
```

Step3: Base OS
```
umount -R /mnt
# vim /etc/hostname
# vim /etc/hosts
# ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

vim /etc/locale.gen
locale-gen
# 这里不建议将 en_US.UTF-8 改为zh_CN.UTF-8 ，这样会导致终端乱码！ 
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "LANG=en_US.UTF-8" >> /etc/profile

# passwd root
# pacman -S grub
# grub-install /dev/sda
# grub-mkconfig -o /boot/grub/grub.cfg

$ systemctl enable NetworkManager 

======== 也可以手动激活网络
nmtui  激活connection  或者 nmcli dev up ens33
```

Step4: Others
```
pacman -S arch-install-scripts  // 有 arch-install, pacstrap
pacman -S openssh 
修改 sshd_config  {PermitRootLogin yes; PasswordAuthentication yes}

$ systemctl enable NetworkManager 
$ systemctl enable sshd

pacman -S less wget  zip unzip
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

# Install 1.7G  包含了gdm（可以直接root登录）
// pacman -S gnome 
# Install 890M  足够使用：桌面环境(文件管理器), 终端, 文件编辑器，系统设置
pacman -S gnome-desktop gnome-terminal gnome-text-editor gnome-system-monitor gnome-control-center gdm

systemctl enable gdm
pacman -S gnome-disk-utility  不是必须
```