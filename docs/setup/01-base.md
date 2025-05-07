---
title: 系统设置
since: 202503
---


## 桌面/命令行

Ubuntu Desktop (中文 + 最小安装)

```
sudo systemctl disable snapd.socket
sudo systemctl disable snapd.seeded.service
sudo systemctl disable snapd.service
```

Fedora Workstation 

```
sudo systemctl set-default graphical.target  
sudo systemctl set-default multi-user.target  
```

## 静态IP

ubuntu  sudo netplan apply
```
步骤1
sudo nano /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
network: {config: disabled}

步骤2
mv /etc/netplan/50-cloud-init.yaml /home

步骤3
sudo nano /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd  # 图形界面 NetworkManager
  ethernets:
    ens33:
      dhcp4: no
      addresses:
        - 192.168.100.130/24
      routes:
        - to: 0.0.0.0/0
          via: 192.168.100.2
      nameservers:
          addresses: # DNS
            - 223.5.5.5
            - 8.8.8.8

动态地址
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:
      dhcp4: yes
```


RPM  systemctl status NetworkManager
```
yum install vim bash-completion
# nmcli con mod ens160 ipv4.address 10.100.0.5/24    #修改IP地址
# nmcli con mod ens160 ipv4.gateway 10.100.0.1        #修改网关
# nmcli con mod ens160 ipv4.dns 10.100.0.1        #修改DNS
# nmcli con mod ens160 ipv4.method manual        #修改IP为手动配置
# nmcli con mod ens160 connection.autoconnect yes    #启用网卡开机自动连接

启用网卡连接
nmcli con up ens160 

查看修改后的IP地址
ip addr show ens160

重新加载网络配置
nmcli c reload

重启网卡（下面的三条命令都可以）
nmcli c up ens160
nmcli d reapply ens160
nmcli d connect ens160
```

## openssh-server

systemctl status sshd
```
$ /etc/ssh/sshd_config:
PasswordAuthentication yes
PermitRootLogin yes

$ ssh -V
OpenSSH 从 8.8 版本开始默认禁用了 ssh-rsa 算法

$ vi ~/.ssh/config
StrictHostKeyChecking no
UserKnownHostsFile /dev/null

Host *
  HostkeyAlgorithms +ssh-rsa
  PubkeyAcceptedAlgorithms +ssh-rsa
```


## Ubuntu Image

修改 locale
```
apt update
apt install language-pack-en  
执行 locale -a

默认
cat /etc/default/locale
LANG=C.UTF-8

修改为
LANG=en_US.UTF8
LC_ALL=en_US.UTF8
LANGUAGE=enUS:en
```

开发工具
```
apt install build-essential
apt install vim less git wget curl

sudo apt install qtbase5-dev qtcreator
sudo apt install rsync
sudo apt install neofetch cpu-x

sudo apt install fcitx5
运行Fcitx5配置，添加五笔拼音，Ctrl+空格。
运行输入法设置，选择fcitx5

sudo apt install ntp -y
sudo systemctl status ntp
解决flatpak网络问题
```

禁止自动更新
```
sudo sed -i.bak 's/1/0/' /etc/apt/apt.conf.d/10periodic
sudo sed -i.bak 's/1/0/' /etc/apt/apt.conf.d/20auto-upgrades
sudo systemctl disable unattended-upgrades
sudo systemctl disable apt-daily.timer
sudo systemctl disable apt-daily.service
sudo systemctl disable apt-daily-upgrade.timer
sudo systemctl disable apt-daily-upgrade.service
#可选
sudo apt remove unattended-upgrades
sudo apt remove update-notifier

禁用内核更新
sudo apt-mark hold linux-generic linux-image-generic linux-headers-generic
# 恢复内核更新
sudo apt-mark unhold linux-generic linux-image-generic linux-headers-generic
```

(笔记本电脑)禁止休眠

```
vi /etc/systemd/sleep.conf

[Sleep]
AllowSuspend=no
AllowHibernation=no
AllowSuspendThenHibernate=no
AllowHybridSleep=no
```

(笔记本电脑)禁用挂起功能

```
末尾追加 /etc/systemd/logind.conf
重启服务 systemctl restart systemd-logind

HandleSuspendKey=ignore
HandleHibernateKey=ignore
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
```


## Fedora Image

```
sudo dnf install @development-tools
sudo dnf install cmake ninja-build
sudo dnf install @rpm-development-tools
sudo dnf install clang
sudo dnf install fedora-packager rpmdevtools

sudo yum install virt-viewer
sudo yum install virt-manager
sudo yum install remmina
sudo yum install rpi-imager
sudo yum install squid
```

firewall
```
sudo firewall-cmd --permanent --add-service=mysql
sudo firewall-cmd --reload
sudo firewall-cmd --list-all

$ sudo firewall-cmd --list-all
FedoraWorkstation (default, active)
  target: default
  ingress-priority: 0
  egress-priority: 0
  icmp-block-inversion: no
  interfaces: eno1
  sources: 
  services: dhcpv6-client http mdns samba-client ssh
  ports: 1025-65535/udp 1025-65535/tcp
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
```

## Alpine Image

docker.io/alpine:latest
```
sudo podman run -it --rm alpine
sudo podman run -it --rm --privileged -v`pwd`:/build  alpine 
/usr/bin/vi  指向 /bin/busybox
cat /etc/alpine-release
cat /etc/os-release

软件仓库
$ less /etc/apk/repositories
http://dl-cdn.alpinelinux.org/alpine/latest-stable/main
http://dl-cdn.alpinelinux.org/alpine/latest-stable/community

软件管理
apk list
apk update
apk search <name>
apk add <name>
apk del <name>

apk add neovim
alias vi='nvim'
```

设置 network
```
https://www.cyberciti.biz/faq/how-to-configure-static-ip-address-on-alpine-linux/

setup-interfaces eth0
service networking restart
ip a
```

设置 locale
```
apk add musl-locales
locale -a

主机名
setup-hostname liveos
```

设置  date
```
https://wiki.alpinelinux.org/wiki/Alpine_setup_scripts#setup-alpine
https://wiki.alpinelinux.org/wiki/Setting_the_timezone

安装timezone
apk add -U tzdata
查看时区列表
ls /usr/share/zoneinfo/

方式1
setup-timezone Asia/Shanghai
方式2
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

参考
```
https://developer.aliyun.com/article/695874  
https://www.cnblogs.com/johnnyzen/p/17805510.html  
```


## Rsync

```
rsync --progress --delete -lprtvvz  rsync://rsync.mirrors.ustc.edu.cn/alpine/v3.22/main/x86_64 .
rsync --progress --delete -lprtvvz  rsync://rsync.mirrors.ustc.edu.cn/slackware/slackware64-current .
```