---
title: CentOS
since: 202412
---


##  CentOS-7-Minimal

CentOS-7-x86_64-Minimal-2009.iso
```
[root@centos ~]# ldd --version
ldd (GNU libc) 2.17

[root@centos ~]# uname -r
3.10.0-1160.el7.x86_64

[root@centos ~]# rpm -qa | wc -l
299

[root@centos ~]# cat /etc/os-release
NAME="CentOS Linux"
VERSION="7 (Core)"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="7"
PRETTY_NAME="CentOS Linux 7 (Core)"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:centos:centos:7"
HOME_URL="https://www.centos.org/"
BUG_REPORT_URL="https://bugs.centos.org/"

CENTOS_MANTISBT_PROJECT="CentOS-7"
CENTOS_MANTISBT_PROJECT_VERSION="7"
REDHAT_SUPPORT_PRODUCT="centos"
REDHAT_SUPPORT_PRODUCT_VERSION="7"

[root@centos ~]# lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   20G  0 disk
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0   19G  0 part
  ├─centos-root 253:0    0   17G  0 lvm  /
  └─centos-swap 253:1    0    2G  0 lvm  [SWAP]
sr0              11:0    1 1024M  0 rom

[root@centos ~]# df -hT
Filesystem              Type      Size  Used Avail Use% Mounted on
devtmpfs                devtmpfs  3.9G     0  3.9G   0% /dev
tmpfs                   tmpfs     3.9G     0  3.9G   0% /dev/shm
tmpfs                   tmpfs     3.9G  8.6M  3.9G   1% /run
tmpfs                   tmpfs     3.9G     0  3.9G   0% /sys/fs/cgroup
/dev/mapper/centos-root xfs        17G  1.3G   16G   8% /
/dev/sda1               xfs      1014M  137M  878M  14% /boot
tmpfs                   tmpfs     799M     0  799M   0% /run/user/0
```

## Desktop

```
yum grouplist
yum grouplist --installed // not support
yum grouplist --ids       // not support

yum groupinstall 'X Window System'
yum groups install "GNOME Desktop"
yum remove gnome-initial-setup

# Others
yum groups install "KDE Plasma Workspaces"
yum groups install "Graphical Administration Tools"


====== startx
systemctl set-default graphical.target
systemctl set-default multi-user.target
```


## LiveCD

Fedora 41
```
yum install glibc-langpack-zh -y
yum install glibc-langpack-en -y
yum install livecd-tools
yum install spin-kickstarts

less /usr/share/doc/livecd-tools/livecd-fedora-minimal.ks
https://github.com/livecd-tools/livecd-tools/blob/main/config/livecd-fedora-minimal.ks

curl "http://mirrors.fedoraproject.org/mirrorlist?repo=rawhide&arch=x86_64"
https://dl.fedoraproject.org/pub/fedora/linux/development/rawhide/Everything/x86_64/os/
https://mirrors.aliyun.com/fedora/development/rawhide/Everything/x86_64/os/

livecd-creator --verbose \
  --config=livecd-fedora-minimal.ks \
  --fslabel="Fedora-41-x86_64-LIVE-2024-en" \
  --title="Fedora 41 LIVE" \
  --product="Fedora 41 LIVE (en)"
```



## CentOS-Base.repo

```
[os]
name=Qcloud centos os - $basearch
baseurl=http://mirrors.cloud.tencent.com/centos/$releasever/os/$basearch/
enabled=1
gpgcheck=1
gpgkey=http://mirrors.cloud.tencent.com/centos/RPM-GPG-KEY-CentOS-7

[updates]
name=Qcloud centos updates - $basearch
baseurl=http://mirrors.cloud.tencent.com/centos/$releasever/updates/$basearch/
enabled=1
gpgcheck=1
gpgkey=http://mirrors.cloud.tencent.com/centos/RPM-GPG-KEY-CentOS-7

[centosplus]
name=Qcloud centosplus - $basearch
baseurl=http://mirrors.cloud.tencent.com/centos/$releasever/centosplus/$basearch/
enabled=0
gpgcheck=1
gpgkey=http://mirrors.cloud.tencent.com/centos/RPM-GPG-KEY-CentOS-7

[cr]
name=Qcloud centos cr - $basearch
baseurl=http://mirrors.cloud.tencent.com/centos/$releasever/cr/$basearch/
enabled=0
gpgcheck=1
gpgkey=http://mirrors.cloud.tencent.com/centos/RPM-GPG-KEY-CentOS-7

[extras]
name=Qcloud centos extras - $basearch
baseurl=http://mirrors.cloud.tencent.com/centos/$releasever/extras/$basearch/
enabled=1
gpgcheck=1
gpgkey=http://mirrors.cloud.tencent.com/centos/RPM-GPG-KEY-CentOS-7

[fasttrack]
name=Qcloud centos fasttrack - $basearch
baseurl=http://mirrors.cloud.tencent.com/centos/$releasever/fasttrack/$basearch/
enabled=0
gpgcheck=1
gpgkey=http://mirrors.cloud.tencent.com/centos/RPM-GPG-KEY-CentOS-7

```