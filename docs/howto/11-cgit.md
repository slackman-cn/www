---
title: CGit
since: 202412
about: https://git-scm.com/downloads
---

## CGit 源码

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

## 编译cgit

https://git.zx2c4.com/cgit/about/

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

## Web UI

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

## 配置文件

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

### Install Web (x)

```
sudo apt install nginx
sudo apt install gitweb  # 主要是配置文件
sudo apt install fcgiwrap

依赖不如单独安装
apt-get install libcgi-fast-perl
apt-get install highlight

------------- cgit
apt install cgit  自动安装 apache2
卸载cgit，不会卸载apache2


----- REF
https://leanhe.dev/posts/2021.05.02.1/  (cgit运行失败)
https://fishilico.github.io/generic-config/etc-server/web/gitweb.html   (gitweb运行成功 + nginx)
```


### 编译git-src 

https://git.mosong.cc/guide/install-git-src.html 
```
https://commandnotfound.cn/linux/1/174/cmp-%E5%91%BD%E4%BB%A4
yum install -y diffutils

yum install curl-devel expat-devel gettext-devel \
    openssl-devel zlib-devel
apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
    libz-dev libssl-dev

tar -zxf git-1.7.2.2.tar.gz
cd git-1.7.2.2
make prefix=/opt/git all
sudo make prefix=/opt/git install
默认安装 /root/{bin,libexec,share}


/usr/lib/git-core/  对应 /opt/git/libexec/git-core
/usr/share/git-core 对应 /opt/git/share/git-core
/usr/share/gitweb 对应 /opt/git/share/gitweb
```


### Nginx dir 

> apt install spawn-fcgi fcgiwrap nginx  (autoindex没用)

```
mkdir -p /data/mirror/githost && cd
touch cgitrc

mkdir lxqt && cd
git clone --mirror https://github.com/lxqt/lxqt
vi lxqt.git/descritpion

---------
mkdir -p /data/mirror/gitpub
vi /etc/nginx/sites-available/default
location /pub/ {
    charset gbk,utf-8;
    alias /data/mirror/gitpub/;
    index off;
    autoindex on;
    autoindex_localtime on;
    autoindex_exact_size off;
}

```