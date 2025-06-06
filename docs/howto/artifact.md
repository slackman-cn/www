---
title: 制品库
since: 202412
---


## Python FileServer

https://stackabuse.com/serving-files-with-pythons-simplehttpserver-module/
```
python3 -m http.server 
python3 -m http.server 8001

-- python2
python -m SimpleHTTPServer 端口号

-- File Upload
pip install uploadserver
python3 -m uploadserver
```

File upload

https://pypi.org/project/uploadserver/#description

https://cloud.tencent.com/developer/article/1858229
```
----- 命令行上传
curl -v http://localhost:8000/upload -F files=@snap2html.lua
curl -v http://192.168.22.239:8000/upload -F files=@xx

-F files=@path/to/file
-T  或者 --upload-file 
md5sum $1 | curl --user ${NEXUS_AUTH} -T - 

----- 网页上传
<body>
<h1>File Upload</h1>
<form action="upload" method="POST" enctype="multipart/form-data">
<input name="files" type="file" multiple />
<br />
<br />
<input type="submit" />
</form>
<p id="task"></p>
<p id="status"></p>
</body>
```

## 文件服务器 FTP(XAMPP)

```
Step1:  Start Filezilla
点击 Admin, 默认无密码，进入设置页面
Edit => Setting  设置端口， 默认21

Step2: Edit => Users
创建用户cccc,  输入密码cccc2023
添加目录D:\pub,  分配给用户cccc, 所有权限(不需要设置home)
```

客户端
```
==== 桌面
文件管理器Network, 输入 ftp://192.168.2.2
[root@archiso ~]# ls /run/user/0/gvfs/
'ftp:host=192.168.2.2'

===== 命令行
install curlftpfs 
curlftpfs cccc:cccc2023@192.168.2.2 ./pub/
```

## 文件服务器 Rsync

```
rsync -avzP ./kylin10sp1-desktop-x64-template.qcow2   cccc@10.31.66.80::backup
rsync -avzP ./newdir/   cccc@10.31.66.80::backup
```

服务器配置
```
echo "cccc:cccc2023" > /etc/rsync.password
chmod 600 /etc/rsync.password

sudo systemctl start rsyncd
sudo firewall-cmd --list-all
```

vi /etc/rsyncd.conf
```
uid = root
gid = root
use chroot = no
max connections = 40
pid file = /var/run/rsyncd.pid
log file = /var/log/rsyncd.log
exclude = lost+found/
transfer logging = yes
timeout = 900
ignore nonreadable = yes
dont compress   = *.gz *.tgz *.zip *.z *.Z *.rpm *.deb *.bz2
auth users = cccc
secrets file = /etc/rsync.password

[backup]
path = /data1/backup
comment = my backup dir
read only = false
```

## 文件服务器 ZFile

https://docs.zfile.vip/install/os-linux
```
mkdir -p /data/pub    # 本地存储

mkdir -p /root/zfile   # 声明安装到的路径
wget --no-check-certificate https://c.jun6.net/ZFILE/zfile-release.war  # 下载 zfile 最新版
unzip zfile-release.war && rm -rf zfile-release.war      # 解压并删除压缩包
chmod +x bin/*.sh                    
./bin/start.sh
http://192.168.122.209:8080

先不用onlyoffice, 好像只能用这个版本
https://docker.aityp.com/image/docker.io/onlyoffice/documentserver:7.1.1
podman run --restart=always --name onlyoffice \
    -p 8081:80 \
    -e JWT_ENABLED=false \
    -d onlyoffice
```

## 文件服务器 SMB

Fedora  Not disaplay in filemanager
https://discussion.fedoraproject.org/t/smbclient-works-but-how-to-mount-as-user/68984/7
```
# mount -t cifs -o rw,vers=3.0,credentials=/data/shareuser //192.168.2.3/Share /data/Share

sudo mount -t cifs -o username=cccc,password=cccc2023,uid=1000,gid=1000 //192.168.2.3/Share /data/Share
```

Fedora FileManager mount

```
/run/user/1000/gvfs/smb-share:server=192.168.2.3,share=share
```


## 目录浏览 Apache

```
   Alias /pub "D:/pub/"
    <Directory "D:/pub">
        Options +Indexes
        IndexOptions FancyIndexing FoldersFirst VersionSort
        IndexOptions NameWidth=60
        IndexOptions IconHeight=16
        IndexOptions IconWidth=16
        
        Require all granted
        ErrorDocument 403 /error/XAMPP_FORBIDDEN.html.var
    </Directory>
```

sudo mkdir /data/pub
```
sudo chown aaa:aaa /data/pub

====== /etc/httpd/conf.d/pub.conf
Alias /pub "/data/pub/"
<Directory "/data/pub">
    Options Indexes MultiViews FollowSymlinks
    AllowOverride None
    Require all granted

        IndexOptions FancyIndexing FoldersFirst VersionSort
        IndexOptions NameWidth=60
        IndexOptions IconHeight=16
        IndexOptions IconWidth=16
</Directory>
```

## 目录浏览 Caddy


```
二进制文件 /usr/loca/bin/caddy
http://mirrors.ustc.edu.cn/debian/pool/main/c/caddy/
https://github.com/caddyserver/caddy/releases/download/v2.8.4/caddy_2.8.4_linux_amd64.tar.gz
配置文件 /lib/systemd/system/caddy.service

[Unit]
Description=Caddy
Documentation=https://caddyserver.com/docs/
After=network.target network-online.target
Requires=network-online.target

[Service]
Type=notify
#User=caddy
#Group=caddy
ExecStart=/usr/local/bin/caddy file-server --browse --root /data/share
#ExecReload=/usr/bin/caddy reload --config /etc/caddy/Caddyfile --force
TimeoutStopSec=5s
LimitNOFILE=1048576
LimitNPROC=512
PrivateTmp=true
ProtectSystem=full
AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
```


官网deb问题
```
sudo apt install caddy
默认会创建caddy用户， 卸载不会删除
使用caddy用户启动服务，访问目录/data/xxx报错403 forbidden
额外启动caddy-api.service
```


## 目录浏览 Nginx 

https://www.f5.com/company/blog/nginx/avoiding-top-10-nginx-configuration-mistakes
```
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

autoindex.html
```
<script>
    !function () {
        website_title = ''
        max_name_length = 60
        enable_readme_md = true
        omit_icon_if_emoji = true
        datetime_format = '%Y-%m-%d %H:%M:%S'
 
        var dom = {
            element: null,
            get: function (o) {
                var obj = Object.create(this)
                obj.element = (typeof o == "object") ? o : document.createElement(o)
                return obj
            },
            add: function (o) {
                var obj = dom.get(o)
                this.element.appendChild(obj.element)
                return obj
            },
            text: function (t) {
                this.element.appendChild(document.createTextNode(t))
                return this
            },
            html: function (s) {
                this.element.innerHTML = s
                return this
            },
            attr: function (k, v) {
                this.element.setAttribute(k, v)
                return this
            }
        }
 
        head = dom.get(document.head)
        head.add('link').attr('rel', 'manifest').attr('href', '/manifest.json')
        head.add('meta').attr('charset', 'utf-8')
        head.add('meta').attr('charset', 'utf-8')
        head.add('meta').attr('name', 'viewport').attr('content', 'width=device-width,initial-scale=1')
 
        if (!document.title) {
            document.write(["<div class=\"container\">",
                "<h3>nginx.conf</h3>",
                "<textarea rows=8 cols=50>",
                "# download autoindex.html to /wwwroot/",
                "location ~ ^(.*)/$ {",
                "    charset utf-8;",
                "    autoindex on;",
                "    autoindex_localtime on;",
                "    autoindex_exact_size off;",
                "    add_after_body /autoindex.html;",
                "}",
                "</textarea>",
                "</div>"].join("\n"))
            return
        }
 
        var bodylines = document.body.innerHTML.split('\n')
        document.body.innerHTML = ''
 
        titlehtml = document.title.replace(/\/$/, '').split('/').slice(1).reduce(function (acc, v, i, a) {
            return acc + '<a href="/' + a.slice(0, i + 1).join('/') + '/">' + v + '</a>/'
        }, '<a href="./">Index</a> of /')
        if (website_title) {
            document.title = website_title + ' - ' + document.title
        }
        head.add('meta').attr('name', 'description').attr('content', document.title)
 
        div = dom.get('div').attr('class', 'container')
        div.add('table').add('tbody').add('tr').add('th').html(titlehtml)
        table = div.add('table').attr('class', 'table-hover').add('tbody')
 
        columns = ['Name', 'Date', 'Size']
        thead = table.add('tr')
        for (i = 0; i < columns.length; i++)
            thead.add('td').add('a').attr('href', 'javascript:sortby(' + i + ')').attr('class', 'octicon arrow-up').text(columns[i]);
        thead.add('td').attr('class', 'octicon').text('Preview')
 
        var insert = function (filename, datetime, size) {
            if (omit_icon_if_emoji && /^(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff]) /.test(filename)) {
                css = ''
            } else if (filename == '../') {
                css = 'octicon file-symlink-directory'
            } else if (/\/$/.test(filename)) {
                css = 'octicon file-directory'
            } else if (/\.(zip|7z|bz2|gz|tar|tgz|tbz2|xz|cab)$/.test(filename)) {
                css = 'octicon file-zip'
            } else if (/\.(py|js|php|pl|rb|sh|bash|lua|sql|go|rs|java|c|h|cpp|cxx|hpp)$/.test(filename)) {
                css = 'octicon file-code'
            } else if (/\.(pdf|ps)$/.test(filename)) {
                css = 'octicon file-pdf'
            } else if (/\.(jpg|png|bmp|gif|ico|webp)$/.test(filename)) {
                css = 'octicon file-media'
            } else if (/\.(flv|mp4|mkv|avi|mkv|vp9)$/.test(filename)) {
                css = 'octicon device-camera-video'
            } else {
                css = 'octicon file'
            }
 
            displayname = decodeURIComponent(filename.replace(/\/$/, ''))
            if (displayname.length > max_name_length)
                displayname = displayname.substring(0, max_name_length - 3) + '..>';
 
            if (!isNaN(Date.parse(datetime))) {
                d = new Date(datetime)
                pad = function (s) { return s < 10 ? '0' + s : s }
                mon = function (m) { return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][m] }
                datetime = datetime_format
                    .replace('%Y', d.getFullYear())
                    .replace('%m', pad(d.getMonth() + 1))
                    .replace('%d', pad(d.getDate()))
                    .replace('%H', pad(d.getHours()))
                    .replace('%M', pad(d.getMinutes()))
                    .replace('%S', pad(d.getSeconds()))
                    .replace('%b', mon(d.getMonth()))
            }
 
            tr = table.add('tr')
            tr.add('td').add('a').attr('class', css).attr('href', filename).text(displayname)
            tr.add('td').text(datetime)
            tr.add('td').text(size == '-' ? '' : size)
            if (/\.(md)$/.test(filename)) {
                tr.add('td').add('input').attr('type', 'button').attr('value', 'Preview').attr('onclick', 'onPreview("' + filename + '")').attr('id', filename)
            } else {
                tr.add('td')
            }
        }
 
        var readme_md = ''
        insert('../', '', '-')
        for (var i in bodylines) {
            if (m = /\s*<a href="(.+?)">(.+?)<\/a>\s+(\S+)\s+(\S+)\s+(\S+)\s*/.exec(bodylines[i])) {
                filename = decodeURIComponent(m[1])
                datetime = m[3] + ' ' + m[4]
                size = m[5]
                if (filename.toLowerCase() == 'readme.md') {
                    readme_md = filename
                }
                insert(filename, datetime, size)
            }
        }
 
        document.documentElement.lang = navigator.language
        document.body.appendChild(div.element)
 
        if (enable_readme_md && readme_md !== '') {
            readme = div.add('table').add('tbody');
            readme.add('tr').add('th').attr('class', 'octicon octicon-book').text(readme_md)
            readme.add('tr').add('td').add('div').attr('id', 'readme').attr('class', 'markdown-body')
            xhr = new XMLHttpRequest()
            xhr.open('GET', location.pathname.replace(/[^/]+$/, '') + readme_md, true)
            xhr.onload = function () {
                if (xhr.status < 200 && xhr.status >= 400)
                    return
                wait('marked', function () {
                    document.getElementById("readme").innerHTML = marked.parse(xhr.responseText)
                    begin = xhr.responseText.indexOf('<!--<script>')
                    end = xhr.responseText.indexOf("\n</" + "script>-->")
                    if (begin < end)
                        div.add('script').html(xhr.responseText.substr(begin + 4 + 8, end + 1 - begin - 4 - 8))
                })
            }
            xhr.send()
 
            div.add('script').attr('src', 'https://jsd.737679.xyz/npm/marked@13.0.3/marked.min.js').attr('crossorigin', 'anonymous')
            div.add('link').attr('rel', 'stylesheet').attr('href', 'https://jsd.737679.xyz/npm/github-markdown-css@5.6.1/github-markdown-light.min.css').attr('crossorigin', 'anonymous')
        }
    }()
 
    function onPreview(filename) {
        myWindow = window.open('', '_blank', '');
        myWindow.document.write("<div id='markdown'></div");
        myWindow.document.title = filename
        ele = myWindow.document.getElementById("markdown")
 
        xhr = new XMLHttpRequest()
        xhr.open('GET', location.pathname.replace(/[^/]+$/, '') + filename, true)
        xhr.onload = function () {
            if (xhr.status < 200 && xhr.status >= 400)
                return
            wait('marked', function () {
                myWindow.document.getElementById("markdown").innerHTML = marked.parse(xhr.responseText)
            })
        }
        xhr.send()
        div.add('script').attr('src', 'https://jsd.737679.xyz/npm/marked@13.0.3/marked.min.js').attr('crossorigin', 'anonymous')
        div.add('link').attr('rel', 'stylesheet').attr('href', 'https://jsd.737679.xyz/npm/github-markdown-css@5.6.1/github-markdown-light.min.css').attr('crossorigin', 'anonymous')
        myWindow.focus();
    }
 
    function wait(name, callback) {
        var interval = 10; // ms
        window.setTimeout(function () {
            if (window[name] && !(window[name] instanceof HTMLElement)) {
                callback(window[name])
            } else if (window[name] instanceof HTMLElement && window[name].innerHTML) {
                callback(window[name])
            } else {
                window.setTimeout(arguments.callee, interval)
            }
        }, interval)
    }
 
    function sortby(index) {
        rows = document.getElementsByClassName('table-hover')[0].rows
        link = rows[0].getElementsByTagName('a')[index]
        arrow = link.className == 'octicon arrow-down' ? 1 : -1
        link.className = 'octicon arrow-' + (arrow == 1 ? 'up' : 'down');
        [].slice.call(rows).slice(2).map(function (e, i) {
            type = e.getElementsByTagName('a')[0].className == 'octicon file-directory' ? 0 : 1
            text = e.getElementsByTagName('td')[index].innerText
            if (index === 0) {
                value = text
            } else if (index === 1) {
                value = new Date(text).getTime()
            } else if (index === 2) {
                m = { 'G': 1024 * 1024 * 1024, 'M': 1024 * 1024, 'K': 1024 }
                value = parseInt(text || 0) * (m[text[text.search(/[KMG]B?$/)]] || 1)
            }
            return { type: type, value: value, index: i, html: e.innerHTML }
        }).sort(function (a, b) {
            if (a.type != b.type)
                return a.type - b.type
            if (a.value != b.value)
                return a.value < b.value ? -arrow : arrow
            return a.index < b.index ? -arrow : arrow
        }).forEach(function (e, i) {
            rows[2 + i].innerHTML = e.html
        })
    }
</script>
 
<style>
    body {
        margin: 0;
        font-family: "ubuntu", "Tahoma", "Microsoft YaHei", Arial, Serif;
    }
 
    .container {
        padding-right: 15px;
        padding-left: 15px;
        margin-right: auto;
        margin-left: auto;
    }
 
    @media (min-width: 768px) {
        .container {
            max-width: 750px;
        }
    }
 
    @media (min-width: 992px) {
        .container {
            max-width: 970px;
        }
    }
 
    @media (min-width: 1200px) {
        .container {
            max-width: 1170px;
        }
    }
 
    table {
        width: 100%;
        max-width: 100%;
        margin-bottom: 20px;
        border: 1px solid #ddd;
        padding: 0;
        border-collapse: collapse;
    }
 
    table th {
        font-size: 14px;
    }
 
    table tr {
        border: 1px solid #ddd;
        padding: 5px;
    }
 
    table tr:nth-child(odd) {
        background: #f9f9f9
    }
 
    table th,
    table td {
        border: 1px solid #ddd;
        font-size: 14px;
        line-height: 20px;
        padding: 3px;
        text-align: left;
    }
 
    a {
        color: #337ab7;
        text-decoration: none;
    }
 
    a:hover,
    a:focus {
        color: #2a6496;
        text-decoration: underline;
    }
 
    table.table-hover>tbody>tr:hover>td,
    table.table-hover>tbody>tr:hover>th {
        background-color: #f5f5f5;
    }
 
    .markdown-body {
        float: left;
        font-family: "ubuntu", "Tahoma", "Microsoft YaHei", Arial, Serif;
    }
 
    /* octicons, see https://phus.lu/code/octicons.html */
    .octicon {
        background-position: center left;
        background-repeat: no-repeat;
        padding-left: 16px;
    }
 
    .arrow-down {
        font-weight: bold;
        text-decoration: none !important;
        background-image: url("data:image/svg+xml;charset=utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='16' viewBox='0 0 10 16'%3E%3Cpolygon id='Shape' points='7 7 7 3 3 3 3 7 0 7 5 13 10 7'%3E%3C/polygon%3E%3C/svg%3E");
    }
 
    .arrow-up {
        font-weight: bold;
        text-decoration: none !important;
        background-image: url("data:image/svg+xml;charset=utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='16' viewBox='0 0 10 16'%3E%3Cpolygon id='Shape' points='5 3 0 9 3 9 3 13 7 13 7 9 10 9'%3E%3C/polygon%3E%3C/svg%3E");
    }
 
    .file {
        background-image: url("data:image/svg+xml;charset=utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='16' viewBox='0 0 12 16'%3E%3Cpath d='M6 5L2 5 2 4 6 4 6 5 6 5ZM2 8L9 8 9 7 2 7 2 8 2 8ZM2 10L9 10 9 9 2 9 2 10 2 10ZM2 12L9 12 9 11 2 11 2 12 2 12ZM12 4.5L12 14C12 14.6 11.6 15 11 15L1 15C0.5 15 0 14.6 0 14L0 2C0 1.5 0.5 1 1 1L8.5 1 12 4.5 12 4.5ZM11 5L8 2 1 2 1 14 11 14 11 5 11 5Z' fill='%237D94AE'/%3E%3C/svg%3E");
    }
 
    .file-directory {
        background-image: url("data:image/svg+xml;charset=utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='16' viewBox='0 0 14 16'%3E%3Cpath d='M13 4L7 4 7 3C7 2.3 6.7 2 6 2L1 2C0.5 2 0 2.5 0 3L0 13C0 13.6 0.5 14 1 14L13 14C13.6 14 14 13.6 14 13L14 5C14 4.5 13.6 4 13 4L13 4ZM6 4L1 4 1 3 6 3 6 4 6 4Z' fill='%237D94AE'/%3E%3C/svg%3E");
    }
 
    .file-symlink-directory {
        background-image: url("data:image/svg+xml;charset=utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='16' viewBox='0 0 14 16'%3E%3Cpath d='M13,4 L7,4 L7,3 C7,2.34 6.69,2 6,2 L1,2 C0.45,2 0,2.45 0,3 L0,13 C0,13.55 0.45,14 1,14 L13,14 C13.55,14 14,13.55 14,13 L14,5 C14,4.45 13.55,4 13,4 L13,4 Z M1,3 L6,3 L6,4 L1,4 L1,3 L1,3 Z M7,12 L7,10 C6.02,9.98 5.16,10.22 4.45,10.7 C3.74,11.18 3.26,11.95 3,13 C3.02,11.36 3.39,10.12 4.13,9.27 C4.86,8.43 5.82,8 7.01,8 L7.01,6 L11.01,9 L7.01,12 L7,12 Z' fill='%237D94AE' /%3E%3C/svg%3E");
    }
 
    .file-zip {
        background-image: url("data:image/svg+xml;charset=utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='16' viewBox='0 0 12 16'%3E%3Cpath d='M8.5 1L1 1C0.4 1 0 1.4 0 2L0 14C0 14.6 0.4 15 1 15L11 15C11.6 15 12 14.6 12 14L12 4.5 8.5 1ZM11 14L1 14 1 2 4 2 4 3 5 3 5 2 8 2 11 5 11 14 11 14ZM5 4L5 3 6 3 6 4 5 4 5 4ZM4 4L5 4 5 5 4 5 4 4 4 4ZM5 6L5 5 6 5 6 6 5 6 5 6ZM4 6L5 6 5 7 4 7 4 6 4 6ZM5 8L5 7 6 7 6 8 5 8 5 8ZM4 9.3C3.4 9.6 3 10.3 3 11L3 12 7 12 7 11C7 9.9 6.1 9 5 9L5 8 4 8 4 9.3 4 9.3ZM6 10L6 11 4 11 4 10 6 10 6 10Z' fill='%237D94AE'/%3E%3C/svg%3E");
    }
 
    .file-code {
        background-image: url("data:image/svg+xml;charset=utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='16' viewBox='0 0 12 16'%3E%3Cpath d='M8.5,1 L1,1 C0.45,1 0,1.45 0,2 L0,14 C0,14.55 0.45,15 1,15 L11,15 C11.55,15 12,14.55 12,14 L12,4.5 L8.5,1 L8.5,1 Z M11,14 L1,14 L1,2 L8,2 L11,5 L11,14 L11,14 Z M5,6.98 L3.5,8.5 L5,10 L4.5,11 L2,8.5 L4.5,6 L5,6.98 L5,6.98 Z M7.5,6 L10,8.5 L7.5,11 L7,10.02 L8.5,8.5 L7,7 L7.5,6 L7.5,6 Z' fill='%237D94AE' /%3E%3C/svg%3E");
    }
 
    .file-binary {
        background-image: url("data:image/svg+xml;charset=utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='16' viewBox='0 0 12 16'%3E%3Cpath d='M4,12 L5,12 L5,13 L2,13 L2,12 L3,12 L3,10 L2,10 L2,9 L4,9 L4,12 L4,12 Z M12,4.5 L12,14 C12,14.55 11.55,15 11,15 L1,15 C0.45,15 0,14.55 0,14 L0,2 C0,1.45 0.45,1 1,1 L8.5,1 L12,4.5 L12,4.5 Z M11,5 L8,2 L1,2 L1,14 L11,14 L11,5 L11,5 Z M8,4 L6,4 L6,5 L7,5 L7,7 L6,7 L6,8 L9,8 L9,7 L8,7 L8,4 L8,4 Z M2,4 L5,4 L5,8 L2,8 L2,4 L2,4 Z M3,7 L4,7 L4,5 L3,5 L3,7 L3,7 Z M6,9 L9,9 L9,13 L6,13 L6,9 L6,9 Z M7,12 L8,12 L8,10 L7,10 L7,12 L7,12 Z' fill='%237D94AE' /%3E%3C/svg%3E");
    }
 
    .file-media {
        background-image: url("data:image/svg+xml;charset=utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='16' viewBox='0 0 12 16'%3E%3Cpath d='M6 5L8 5 8 7 6 7 6 5 6 5ZM12 4.5L12 14C12 14.6 11.6 15 11 15L1 15C0.5 15 0 14.6 0 14L0 2C0 1.5 0.5 1 1 1L8.5 1 12 4.5 12 4.5ZM11 5L8 2 1 2 1 13 4 8 6 12 8 10 11 13 11 5 11 5Z' fill='%237D94AE'/%3E%3C/svg%3E");
    }
 
    .file-pdf {
        background-image: url("data:image/svg+xml;charset=utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='16' viewBox='0 0 12 16'%3E%3Cpath d='M8.5,1 L1,1 C0.44771525,1 0,1.44771525 0,2 L0,14 C0,14.5522847 0.44771525,15 1,15 L11,15 C11.5522847,15 12,14.5522847 12,14 L12,4.5 L8.5,1 Z M1,2 L5,2 C4.88021121,2.03682695 4.77292941,2.10604101 4.69,2.2 C4.57596619,2.33544491 4.49698141,2.4968486 4.46,2.67 C4.34406753,3.15093672 4.3136037,3.64851254 4.37,4.14 C4.42970074,4.74889969 4.54348307,5.35127671 4.71,5.94 C4.39913981,6.85020329 4.02832805,7.73881526 3.6,8.6 C3.1,9.6 2.8,10.26 2.69,10.44 C2.45490116,10.527838 2.22458325,10.6279762 2,10.74 C1.63797844,10.9047863 1.30126564,11.1202825 1,11.38 L1,2 L1,2 Z M5.42,6.8 C5.65615226,7.57227694 6.05511596,8.28495569 6.59,8.89 C6.8651023,9.12723152 7.18463148,9.30739159 7.53,9.42 C6.89,9.51 6.3,9.62 5.72,9.75 C5.10224214,9.89929979 4.49707287,10.0965649 3.91,10.34 C3.32292713,10.5834351 4.13,9.9 4.52,9.09 C4.8853939,8.349364 5.18973729,7.58014443 5.43,6.79 L5.43,6.79 L5.42,6.8 Z M11,14 L1.5,14 C1.44352149,14.0065306 1.38647851,14.0065306 1.33,14 C1.60061185,13.9042665 1.84896383,13.7545749 2.06,13.56 C2.76700578,12.8583965 3.36677981,12.0564515 3.84,11.18 C4.15,11.05 4.42,10.95 4.65,10.87 L5.07,10.73 C5.52,10.6 6.01,10.5 6.51,10.4 C7.01,10.3 7.51,10.24 7.99,10.2 C8.43725403,10.4162545 8.9023067,10.5935768 9.38,10.73 C9.78288787,10.8407498 10.1943157,10.9176835 10.61,10.96 L10.99,10.96 L10.99,14 L10.99,14 L11,14 Z M11,9.14 C10.7958695,9.02690387 10.5816018,8.93316173 10.36,8.86 C10.113806,8.8009088 9.86279363,8.76409365 9.61,8.75 C9.19880419,8.75303183 8.78812424,8.77974272 8.38,8.83 C8.0073597,8.68541471 7.66736947,8.46782096 7.38,8.19 C6.78281632,7.51840635 6.34221217,6.72258646 6.09,5.86 C6.20098287,5.19851127 6.26779732,4.53036675 6.29,3.86 C6.30923951,3.61037016 6.30923951,3.35962984 6.29,3.11 C6.35921678,2.80151577 6.28575056,2.47826438 6.09,2.23 C5.92718989,2.07232702 5.70638123,1.9890713 5.48,2 L8,2 L11,5 L11,9.13 L11,9.13 L11,9.14 Z' fill='%237D94AE' /%3E%3C/svg%3E");
    }
 
    .device-camera-video {
        background-image: url("data:image/svg+xml;charset=utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 16 16'%3E%3Cpath d='M15.2,2.09 L10,5.72 L10,3 C10,2.45 9.55,2 9,2 L1,2 C0.45,2 0,2.45 0,3 L0,12 C0,12.55 0.45,13 1,13 L9,13 C9.55,13 10,12.55 10,12 L10,9.28 L15.2,12.91 C15.53,13.14 16,12.91 16,12.5 L16,2.5 C16,2.09 15.53,1.86 15.2,2.09 L15.2,2.09 Z' fill='%237D94AE' /%3E%3C/svg%3E");
    }
 
    .octicon-book {
        padding-left: 20px;
        background-image: url("data:image/svg+xml;charset=utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 16 16'%3E%3Cpath d='M3,5 L7,5 L7,6 L3,6 L3,5 L3,5 Z M3,8 L7,8 L7,7 L3,7 L3,8 L3,8 Z M3,10 L7,10 L7,9 L3,9 L3,10 L3,10 Z M14,5 L10,5 L10,6 L14,6 L14,5 L14,5 Z M14,7 L10,7 L10,8 L14,8 L14,7 L14,7 Z M14,9 L10,9 L10,10 L14,10 L14,9 L14,9 Z M16,3 L16,12 C16,12.55 15.55,13 15,13 L9.5,13 L8.5,14 L7.5,13 L2,13 C1.45,13 1,12.55 1,12 L1,3 C1,2.45 1.45,2 2,2 L7.5,2 L8.5,3 L9.5,2 L15,2 C15.55,2 16,2.45 16,3 L16,3 Z M8,3.5 L7.5,3 L2,3 L2,12 L8,12 L8,3.5 L8,3.5 Z M15,3 L9.5,3 L9,3.5 L9,12 L15,12 L15,3 L15,3 Z' /%3E%3C/svg%3E");
    }
 
    .globe {
        padding-left: 20px;
        background-image: url("data:image/svg+xml;charset=utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='16' viewBox='0 0 14 16'%3E%3Cpath d='M7,1 C3.14,1 0,4.14 0,8 C0,11.86 3.14,15 7,15 C7.48,15 7.94,14.95 8.38,14.86 C8.21,14.78 8.18,14.13 8.36,13.77 C8.55,13.36 9.17,12.32 8.56,11.97 C7.95,11.62 8.12,11.47 7.75,11.06 C7.38,10.65 7.53,10.59 7.5,10.48 C7.42,10.14 7.86,9.59 7.89,9.54 C7.91,9.48 7.91,9.27 7.89,9.21 C7.89,9.13 7.62,8.99 7.55,8.98 C7.49,8.98 7.44,9.09 7.35,9.11 C7.26,9.13 6.85,8.86 6.76,8.78 C6.67,8.7 6.62,8.55 6.49,8.44 C6.36,8.31 6.35,8.41 6.16,8.33 C5.97,8.25 5.36,8.02 4.88,7.85 C4.4,7.66 4.36,7.38 4.36,7.19 C4.34,6.99 4.06,6.72 3.94,6.52 C3.8,6.32 3.78,6.05 3.74,6.11 C3.7,6.17 3.99,6.89 3.94,6.92 C3.89,6.94 3.78,6.72 3.64,6.54 C3.5,6.35 3.78,6.45 3.34,5.59 C2.9,4.73 3.48,4.29 3.51,3.84 C3.54,3.39 3.89,4.01 3.7,3.71 C3.51,3.41 3.7,2.82 3.56,2.6 C3.43,2.38 2.68,2.85 2.68,2.85 C2.7,2.63 3.37,2.27 3.84,1.93 C4.31,1.59 4.62,1.87 5,1.98 C5.39,2.11 5.41,2.07 5.28,1.93 C5.15,1.8 5.34,1.76 5.64,1.8 C5.92,1.85 6.02,2.21 6.47,2.16 C6.94,2.13 6.52,2.25 6.58,2.38 C6.64,2.51 6.52,2.49 6.2,2.68 C5.9,2.88 6.22,2.9 6.75,3.29 C7.28,3.68 7.13,3.04 7.06,2.74 C6.99,2.44 7.45,2.68 7.45,2.68 C7.78,2.9 7.72,2.7 7.95,2.76 C8.18,2.82 8.86,3.4 8.86,3.4 C8.03,3.84 8.55,3.88 8.69,3.99 C8.83,4.1 8.41,4.29 8.41,4.29 C8.24,4.12 8.22,4.31 8.11,4.37 C8,4.43 8.09,4.59 8.09,4.59 C7.53,4.68 7.65,5.28 7.67,5.42 C7.67,5.56 7.29,5.78 7.2,6 C7.11,6.2 7.45,6.64 7.26,6.66 C7.07,6.69 6.92,6 5.95,6.25 C5.65,6.33 5.01,6.66 5.36,7.33 C5.72,8.02 6.28,7.14 6.47,7.24 C6.66,7.34 6.41,7.77 6.45,7.79 C6.49,7.81 6.98,7.81 7.01,8.4 C7.04,8.99 7.78,8.93 7.93,8.95 C8.1,8.95 8.63,8.51 8.7,8.5 C8.76,8.47 9.08,8.22 9.73,8.59 C10.39,8.95 10.71,8.9 10.93,9.06 C11.15,9.22 11.01,9.53 11.21,9.64 C11.41,9.75 12.27,9.61 12.49,9.95 C12.71,10.29 11.61,12.04 11.27,12.23 C10.93,12.42 10.79,12.87 10.43,13.15 C10.07,13.43 9.62,13.79 9.16,14.06 C8.75,14.29 8.69,14.72 8.5,14.86 C11.64,14.16 13.98,11.36 13.98,8.02 C13.98,4.16 10.84,1.02 6.98,1.02 L7,1 Z M8.64,7.56 C8.55,7.59 8.36,7.78 7.86,7.48 C7.38,7.18 7.05,7.25 7,7.2 C7,7.2 6.95,7.09 7.17,7.06 C7.61,7.01 8.15,7.47 8.28,7.47 C8.41,7.47 8.47,7.34 8.69,7.42 C8.91,7.5 8.74,7.55 8.64,7.56 L8.64,7.56 Z M6.34,1.7 C6.29,1.67 6.37,1.62 6.43,1.56 C6.46,1.53 6.45,1.45 6.48,1.42 C6.59,1.31 7.09,1.17 7,1.45 C6.89,1.72 6.42,1.75 6.34,1.7 L6.34,1.7 Z M7.57,2.59 C7.38,2.57 6.99,2.54 7.05,2.45 C7.35,2.17 6.96,2.07 6.71,2.07 C6.46,2.05 6.37,1.91 6.49,1.88 C6.61,1.85 7.1,1.9 7.19,1.96 C7.27,2.02 7.71,2.21 7.74,2.34 C7.76,2.47 7.74,2.59 7.57,2.59 L7.57,2.59 Z M9.04,2.54 C8.9,2.63 8.21,2.13 8.09,2.02 C7.53,1.54 7.2,1.71 7.09,1.61 C6.98,1.51 7.01,1.42 7.2,1.27 C7.39,1.12 7.89,1.33 8.2,1.36 C8.5,1.39 8.86,1.63 8.86,1.91 C8.88,2.16 9.19,2.41 9.05,2.54 L9.04,2.54 Z' /%3E%3C/svg%3E");
    }
</style>
```
```