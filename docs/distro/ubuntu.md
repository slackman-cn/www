---
title: Ubuntu
since: 202412
---


## Ubuntu Desktop 

(中文 + 最小安装)

https://www.brsmedia.in/how-to-disable-snap-on-ubuntu-22-04/
```
sudo systemctl set-default graphical.target  
sudo systemctl set-default multi-user.target  

sudo systemctl disable snapd.socket
sudo systemctl disable snapd.seeded.service
sudo systemctl disable snapd.service

Firefox 会使用 snap仓库
https://ftp.mozilla.org/pub/firefox/releases/137.0.2/linux-x86_64/en-GB/firefox-137.0.2.tar.xz
ln -s /opt/firefox/firefox /usr/bin/firefox

离线安装 VSCode, 不能root运行; 切换到user, 执行startx, 初始设置，打开命令行执行code

apt-get install --no-install-recommends <xxx>
apt-cache show ubuntu-desktop | grep "Depends"
apt-cache show ubuntu-desktop | grep "Recommends"
```


## Ubuntu Server

```
非常多, 都会安装snap firefox
sudo apt install ubuntu-gnome-desktop
sudo apt install task-lxqt-desktop
sudo apt install lxqt
sudo apt install lubuntu-desktop

//sudo dpkg-reconfigure sddm

最小安装 (有设置，有壁纸，有文件管理器) 
sudo apt install --no-install-recommends ubuntu-desktop-minimal // 没有网络管理器，联网报错
sudo apt install ubuntu-desktop-minimal     // 网络正常，正常安装页面

最小安装 (有设置，没有壁纸)
sudo apt install gnome-session gnome-terminal 


-------------------- On Ubuntu -------------------- 
//sudo apt install lxqt sddm
sudo apt --no-install-recommends install lxqt
sudo apt install sddm
 apt info lxqt-system-theme
sudo apt install papirus-icon-theme // 解决 icon 不显示问题
>> lxqt-about
>> lxqt-config
>> lxqt-config-appearance  // 方法2，解决 icon 不显示问题
sudo apt purge lxqt sddm
sudo apt autoremove

-------------------- On Fedora -------------------- 
dnf install @lxqt
dnf remove @lxqt
```

i3 基于x11 (包含很多软件)
```
sudo apt install i3
dpkg -l | grep x11-xserver-utils

初始设置
mkdir -p ~/.config/i3
cp /etc/i3/config ~/.config/i3/

sudo apt install xserver-xorg xinit
startx

======= i3 命令
Alt + Enter     打开命令行
Alt + Shift + Q 关闭
```

Hypyland 基于 xwayland  (安装很多开发环境gcc,cmake,golang,qt,gtk, github仓库)
```
不能root运行
git clone -b 24.04 --depth=1  https://github.com/JaKooLit/Ubuntu-Hyprland.git ~/Ubuntu-Hyprland-24.04
./install.sh
```


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


chroot (QEMU)

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


## Live CD

```
sudo apt install live-build  版本号1.20230502
sudo apt install debootstrap

sudo mkdir /mnt/live  && cd 
sudo lb config
sudo lb build

sudo  lb config --distribution bookworm \
  --archive-areas "main contrib non-free non-free-firmware" \
  --mirror-binary https://mirrors.163.com/debian \
  --mirror-binary-security https://mirrors.163.com/debian-security \
  --mirror-bootstrap https://mirrors.163.com/debian \
  --mirror-chroot https://mirrors.163.com/debian \
  --mirror-chroot-security https://mirrors.163.com/debian-security \
  --mirror-debian-installer https://mirrors.163.com/debian

最终生成 live-image-amd64.hybrid.iso  (总共284 packages)
默认用户”user“密码”live“
默认 main https://deb.debian.org/debian  
完整系统 
deb http://mirrors/ustc.edu.cn/debian bookworm  main contrib non-free non-free-firmware
deb http://mirrors/ustc.edu.cn/debian bookworm-updates  main contrib non-free non-free-firmware

选择ISO混合镜像
lb config --binary-images iso-hybrid --architecture amd64 --distribution sid --boot-loaders syslinux
```

Debian-XFCE
```
cd /mnt/live-xfce
sudo lb config --distribution bookworm \
  --debian-installer live \
  --debian-installer-gui true \
  --iso-application "DebianXfce" \
  --iso-publisher "DebianXfce Project" \
  --iso-volume "DebianXfce Live" \
  --archive-areas "main contrib non-free non-free-firmware" \
  --security false \
  --mirror-binary https://mirrors.163.com/debian \
  --mirror-bootstrap https://mirrors.163.com/debian \
  --mirror-chroot https://mirrors.163.com/debian \
  --mirror-debian-installer https://mirrors.163.com/debian

$ dpkg -l | wc -l
288

重命名
DebianXfce-live-12.7-amd64-20230502.iso

(fcitx不显示zh选项，应该是fcitx5-chinese-addons， 而且系统是英文)

----- conf/package-lists/application.list.chroot    (1.63 GB  安装包823)
(没有build-essential, 没有xfce-terminal[uterm代替], 没有dock,  没有mousepad editor)
xfce4
firefox-esr
vim
git
wget
rsync
fcitx5

---- conf/package-lists/application.list.chroot  (2.06 GB  安装包1363)
(没有build-essential, 有一套libreoffice, 有xfce-terminal, 有dock, 有mousepad)
task-xfce-desktop  (软件数量太夸张了，尽量不要用这个)
firefox-esr
vim
git
wget
rsync
fcitx5

--mirror-binary：定义 Live 系统用户使用的软件源镜像，配置在最终的二进制映像中。
--mirror-binary-security：定义 Live 系统用户使用的安全更新软件源镜像，配置在最终的二进制映像中。

--mirror-bootstrap：定义构建过程中 bootstrap 阶段使用的软件源镜像。
--mirror-chroot：定义构建过程中 chroot 阶段使用的软件源镜像。
--mirror-chroot-security：定义构建过程中 chroot 阶段使用的安全更新软件源镜像。
--mirror-debian-installer：定义构建过程中用于获取 Debian Installer 的软件源镜像。
```