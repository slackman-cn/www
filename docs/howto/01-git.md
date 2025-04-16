---
title: 代码库 Git
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