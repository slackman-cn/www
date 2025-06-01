---
title: ArchLinux from Scratch
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

## blackarch-linux-2023.05.01

```
root:x:0:0::/root:/bin/bash
Password : blackarch

liveuser:x:1000:984::/home/liveuser:/bin/zsh
Password : blackarch

$ systemctl status systemd-networkd.service
$ systemctl enable --now NetworkManager.service

$ vim /etc/ssh/sshd_config
$ systemctl start sshd

$ pacman -Q | wc -l
1527
6374
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

Step3: systemd-boot 轻量，代替grub
```
$> rm -rf /boot/EFI /boot/grub

检查引导
$> bootctl

创建 /boot/EFI  /boot/loader
$> bootctl install

修改 /boot/loader/loader.conf
default arch.conf
timeout 3
console-mode keep

新建 /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=12db8920-0759-424d-b5a7-3298b31ab614 rw
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

## xorg-xinit

https://bashcommandnotfound.cn/article/linux-xinit-command

xorg 不包含xorg-xinit; 可选 xterm
```
$> pacman -S xorg xorg-xinit 
$> pacman -Q | grep xorg

可能是浏览器
pacman -S w3m
w3m suckless.org

wget http://dl.suckless.org/dwm/dwm-6.2.tar.gz
wget http://dl.suckless.org/tools/dmenu-5.0.tar.gz
wget http://dl.suckless.org/st/st-0.8.4.tar.gz

$> pacman -S base-devel
cd dwm
make
make install  # /usr/local/bin/dwm


cd dmenu
make
make install  # /usr/local/bin/dmenu


cd st
make 
make install  # /usr/local/bin/st
```

重启reboot ;; 执行 startx;; Alt + Shift + Enter
```
创建  ~/.xinitrc
exec dwm
```

配置 fluxbox
```
$> pacman -S fluxbox  xterm
/usr/bin/startfluxbox

创建  ~/.xinitrc
#!/bin/sh
xterm &
exec startfluxbox


重启reboot ;; 执行 startx;; 右键xterm
或者执行 xinit

https://man.archlinux.org/man/startx.1.en
优先级
$(HOME)/.xinitrc
$(HOME)/.xserverrc
/etc/X11/xinit/xinitrc
```

登录启动启动 startx
```
#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
   exec startx
 fi
 
========= 
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    startx
fi

========
vim ~/.zprofile

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
```

自动登录 root

https://unix.stackexchange.com/questions/42359/how-can-i-autologin-to-desktop-with-systemd
```
mkdir -p /etc/systemd/system/getty@tty1.service.d/
touch /etc/systemd/system/getty@tty1.service.d/override.conf

[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin root --noclear %I $TERM

==== 参考
systemctl edit getty@tty1
systemctl -q is-active graphical.target && echo foobar
```

## Desktop environment or Tile window manager ? 

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

## Arch build system 

https://wiki.archlinux.org/title/Arch_build_system

https://superuser.com/questions/1350308/get-source-for-arch-linux-package

https://lists.archlinux.org/pipermail/arch-general/2018-August/045460.html

The Arch build system (ABS) is a system for building and packaging software from source code
```
$> sudo pacman -Syu base-devel git

asp export nano
makepkg -s --skippgpcheck

$> pacman -Q | grep nano
$> sudo pacman -R nano
$> sudo pacman -S
$> sudo pacman -U nano-7.2-1-x86_64.pkg.tar.zst

没有这个软件
$> sudo pacman -S asp
Download the PKGBUILD 
$> asp export <package_name>
Download the source files
$> cd xxx
$> makepkg -do

-s选项会自动安装所有依赖包，
-i选项会在编译完成后自动安装生成的包
$> makepkg -si

========  Usage: get-source xxx
function get-source()
{
    asp export $1 && \
    pushd $1 && \
    makepkg -do --skippgpcheck && \
    pushd src
}

========= asp可能是AUR仓库
https://www.maketecheasier.com/use-aur-in-arch-linux
$> useradd cnki -G wheel -m
$> passwd cnki
$> nano /etc/sudoers.d/cnki
cnki ALL=(ALL:ALL) ALL

su cnki
cd /tmp

https://aur.archlinux.org/packages/asp
只有一个PKGBUILD
git clone https://aur.archlinux.org/asp.git  --depth=1
makepkg -si
makepkg -si --skippgpcheck

git clone https://aur.archlinux.org/yay.git --depth=1
makepkg -si

yay -Ss package

```

## About Links

[pacman包管理] https://knightwood.github.io/posts/dd409eba/