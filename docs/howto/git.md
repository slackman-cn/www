---
title: 代码库
since: 202412
about: https://git-scm.com/downloads
---


## Git Client

sudo apt install git git-lfs
```
>> ssh -V
>> vi ~/.ssh/config
StrictHostKeyChecking no
UserKnownHostsFile /dev/null

Host *
  HostkeyAlgorithms +ssh-rsa
  PubkeyAcceptedAlgorithms +ssh-rsa

>> /etc/ssh/sshd_config:
PasswordAuthentication yes
PermitRootLogin yes

报错原因
https://www.cnblogs.com/fatedeity/p/17267481.html  
https://blog.twofei.com/881/  
```

```
git config --global user.name  "gechao1000"
git config --global user.email "gechao1000@outlook.com"
git config --global core.autocrlf input
git config --global credential.helper store

// default 15m, set 1h
git config --global credential.helper cache
git config credential.helper 'cache --timeout=3600' 

>> git lfs install
git lfs track "*.pdf"

git init --bare xxx.git
echo "Some short description" > ~/repos/[repo-name]/description

Git 理解警告“LF将被CRLF替换”
git config --global core.autocrlf false
```

## Git Server

```
ssh:// - default port 22
git:// - default port 9418
http:// - default port 80
https:// - default port 443

git clone --mirror https://github.com/ninja-build/ninja
git clone  git://localhost/github.com/ninja-build/ninja

$ export GIT_CONFIG_GLOBAL=/gitmirror.conf
$ vi /gitmirror.conf
[http]
    sslVerify = false
[url "git://192.168.2.2/github.com"]
    insteadOf = https://github.com
```

## Forgejo Service

https://forgejo.org/docs/latest/admin/installation-binary/

```
sudo chmod 755 /usr/local/bin/forgejo

sudo mkdir /data/forgejo
sudo chown cccc:cccc /data/forgejo

########## app.ini
.....
[i18n]
LANGS = zh-CN,en-US
NAMES = 简体中文,English

[migrations]
ALLOWED_DOMAINS = 127.0.0.1,192.168.22.239
ALLOW_LOCALNETWORKS = true
```

/usr/lib/systemd/system/forgejo.service
```
wget https://codeberg.org/forgejo/forgejo/raw/branch/forgejo/contrib/systemd/forgejo.service

[Unit]
Description=Forgejo (Beyond coding. We forge.)
After=syslog.target
After=network.target

[Service]
RestartSec=2s
Type=simple
User=cccc
Group=cccc
WorkingDirectory=/data/forgejo/

ExecStart=/usr/local/bin/forgejo web --config /data/forgejo/app.ini
Restart=always
Environment=USER=cccc HOME=/home/cccc FORGEJO_WORK_DIR=/data/forgejo

[Install]
WantedBy=multi-user.target
```

## Git Daemon Service

```
[Unit]
Description=Start Git Daemon

[Service]
ExecStart=/usr/bin/git daemon --base-path=/data/cgit --export-all --reuseaddr --informative-errors --verbose

Restart=always
RestartSec=2s

StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=git-daemon

User=root
Group=root

[Install]
WantedBy=multi-user.target

```

## CGit

编译cgit 需要先下载git源码
```
https://git-scm.com/downloads
https://github.com/git/git/tags

$ git clone https://git.zx2c4.com/cgit
$ git clone https://www.thedroneely.com/git/thedroneely/cgit

方式1 git submodule init && git submodule update
方式2 make get-git
    https://www.kernel.org/pub/software/scm/git/git-2.46.0.tar.xz 
    && rm -rf git
    && mv git-2.46.0 git
```

编译cgit
```
podman run -it --rm -v `pwd`:/build anolis bash
yum install -y which 
yum install -y gcc make
yum install -y openssl-devel
[openeuler] yum install -y findutils

$ make clean
$ make
$ sudo make install

install -m 0755 -d /var/www/htdocs/cgit
install -m 0755 cgit /var/www/htdocs/cgit/cgit.cgi
install -m 0755 -d /var/www/htdocs/cgit
install -m 0644 cgit.css /var/www/htdocs/cgit/cgit.css
install -m 0644 cgit.js /var/www/htdocs/cgit/cgit.js
install -m 0644 cgit.png /var/www/htdocs/cgit/cgit.png
install -m 0644 favicon.ico /var/www/htdocs/cgit/favicon.ico
install -m 0644 robots.txt /var/www/htdocs/cgit/robots.txt
install -m 0755 -d /usr/local/lib/cgit/filters
cp -r filters/* /usr/local/lib/cgit/filters
```

fcgi
```
[anolis]
yum install epel-release
yum install fcgi fcgiwrap
yum install spawn-fcgi

[openeuler]
yum install fcgi
yum install spawn-fcgi

[openeuler 编译fcgiwrap]
https://gitee.com/src-oepkgs/fcgiwrap/tree/master
https://github.com/gnosek/fcgiwrap
yum install -y automake autoconf
yum install -y fcgi-devel


yum install -y nginx  
openEuler和anolis都改了nginx源码和首页

spawn-fcgi -s /var/run/fcgiwrap.socket -M 0666 -U nginx -- /usr/sbin/fcgiwrap
ps -ef | grep fcgi
```

nginx.conf
```
location ~ ^/cgit\.(png|css)$ { root /var/www/htdocs/cgit/; }
location ~ ^/cgit(/.*) {
    fastcgi_pass unix:/var/run/fcgiwrap.socket;
    fastcgi_param SCRIPT_FILENAME /var/www/htdocs/cgit/cgit.cgi;
    fastcgi_param PATH_INFO       $1;
    fastcgi_param CGIT_CONFIG     /data1/githost/cgitrc;
    include fastcgi_params;
}

server {
	listen       80;
	server_name  githost;
	location / {
		rewrite ^/(.*) http://10.31.66.80/cgit/$1 permanent;
	}
}
```

cgitrc
```
virtual-root=/cgit
scan-path=/data1/githost/

# Here are some default values
root-title=Git repository mirror
root-desc=a fast webinterface for the git dscm

# Custom configuration
clone-prefix=http://githost

# Syntax highlighting
source-filter=/usr/local/lib/cgit/filters/syntax-highlighting.sh
```