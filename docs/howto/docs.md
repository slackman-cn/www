---
title: 文档库
since: 202412
---

## 本地文档 

https://obsidian.md/download

```
设置 -> 文件链接
- 附件存放位置 【当前目录指定文件夹】
- 内部链接类型 【当前笔记相对路径】

设置 -> 编辑器
- 关闭拼写检查

切换主题  Notation 2

touch .ignore
## Obsidian Desktop
.obsidian/
```

https://joplinapp.org/

缺点：文件名随机字符串


https://simplenote.com/

缺点：必须登录



## 在线文档 shpinx

```
>> user-wide
sudo apt install python3-venv
python3 -m venv vbuild
source vbuild/bin/activate
deactive

>> system-wide
sudo apt install python3-sphinx python3-sphinx-rtd-theme
sphinx-quickstart && make html
python3 -m http.server -d ./build/html/
html_theme = 'sphinx_rtd_theme'
```

## 在线文档 wiki.js

[https://js.wiki/] open source Wiki software

v2 支持导出， 不支持导入。 预计v3 支持

目前只能迁移 postgres 数据库
```
https://docs.vultr.com/install-wiki-js-with-node-js-postgresql-and-nginx-on-ubuntu-20-04-lts
https://docker.aityp.com/image/docker.io/postgres:alpine

docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/postgres:alpine
docker tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/postgres:alpine  docker.io/postgres:alpine

docker pull swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/postgres:15-alpine
docker tag  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/postgres:15-alpine  docker.io/postgres:15-alpine

docker run --name postgres  -p 5432:5432 \
  --restart unless-stopped \
  -e POSTGRES_DB=wiki \
  -e POSTGRES_PASSWORD=wikijsrocks \
  -e POSTGRES_USER=wikijs \
  -v /data/mirror/wiki/postgres:/var/lib/postgresql/data \
  -d postgres:15-alpine
```

自定义
```
wget https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/v22.6.0/node-v22.6.0-linux-x64.tar.gz
wget https://github.com/Requarks/wiki/releases/latest/download/wiki-js.tar.gz
ln -s /opt/node-v20/bin/node /usr/local/bin/

全部默认 cp config.sample.yml config.yml
host: localhost
port: 5432
user: wikijs
pass: wikijsrocks
db: wiki

$ /usr/lib/systemd/system/wikijs.service
[Unit]
Description=Wiki.js
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/node server
Restart=always
User=root
Environment=NODE_ENV=production
WorkingDirectory=/data/mirror/wiki

[Install]
WantedBy=multi-user.target
```

## 在线文档 MkDocs

[https://www.mkdocs.org/] Project documentation with Markdown
```
sudo apt install python3-venv
sudo apt install python3-pip

python3 -m venv mysite
source bin/activate
pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
pip install mkdocs

mkdocs new website
mkdocs serve


# sudo apt install python3-venv python3-pip
# python3 -m venv vbuild && source bin/active
# pip install mkdocs
# pip install mkdocs-material
# 
# cd xyz && mkdocs .
# mkdocs serve

mkdocs build
```

新增页面
```
curl 'https://jaspervdj.be/lorem-markdownum/markdown.txt' > docs/about.md

$ vi mkdocs.yml
site_name: Slackman
plugins: []
nav:
 - Home: index.md
 - About: about.md

nav:
 - SCRIPT:
   - script/source.md
   - script/tools.md
 - HOWTO:
   - howto/mkdocs.md
   - howto/cgit.md
 - REPOSITORY: about.md
```


## MkDocs 主题

```
$ vi mkdocs.yml
theme:
  name: readthedocs
```

https://squidfunk.github.io/mkdocs-material/reference/grids/
```
pip install mkdocs-material
$ vi mkdocs.yml
theme:
 name: material
 language: zh
 logo: xp.png
 favicon: linux.ico
 palette:
   primary: teal
 features:
   - navigation.tabs
extra:
 generator: false
```

mkdocs.yaml
```
site_name: SLACKMAN.CN
site_url: https://slackman.cn
repo_url: https://github.com/slackman-cn/site.git
edit_uri: '?'
theme:
 name: material
 language: zh
 logo: xp.png
 favicon: linux.ico
 palette:
   primary: teal
 features:
   - navigation.tabs
extra:
 generator: false
markdown_extensions: 
  - attr_list
  - md_in_html
plugins: []

nav:
 - HOWTO:  '/howto/'
 - SCRIPT: '/script/'
 - SYSTEM: '/system/'
 - About: about.md
```

目录 list-item
```
<div class="grid cards" markdown>

- [Boot CD](./01-bootcd)  启动盘
- [Disk Image](./02-diskimage)  磁盘镜像

</div>

<div class="grid cards" markdown>

- [MkDocs](./01-mkdoc) 

    ---
    Project documentation with Markdown

- [Wiki.js](./03-wikijs)   <sub>https://js.wiki/</sub>

    ---
    open source Wiki software

- [CGit](./02-cgit)    <sub>https://git-scm.com/downloads</sub>

    ---
    web interface for Git repositories

</div>
```


## MkDocs 自定义样式 

(Support IE8)
```
theme:
  name: null
  custom_dir: 'theme/'

extra:
  version: 0.13.0
  links:
    - https://github.com/mkdocs
    - https://docs.readthedocs.org/en/latest/builds.html#mkdocs
    - https://www.mkdocs.org/
```

https://pure-css.github.io/    \

https://v3.bootcss.com/  
```
https://www.w3schools.com/w3js/
 <script src="https://www.w3schools.com/lib/w3.js"></script> 
<script src="w3.js"></script> 

https://www.w3schools.com/w3css/default.asp
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> 
<link rel="stylesheet" href="w3.css"> 

https://nextui.org/docs/components/navbar
https://www.w3schools.com/Css/css_navbar.asp
https://www.w3schools.com/csS/css_navbar_horizontal.asp

https://foolishdeveloper.com/navigation-bar-html-css-javascript/
https://onaircode.com/html-css-navbar-examples/
https://codepen.io/acarlie/pen/JjPKmmV


这个最好, 尽量减小体积
https://codepen.io/ariona/pen/pENZXW
https://codepen.io/pec-man/pen/bGbeXqZ   
(直接使用native, 不要用jquery, 太大了还没法精简)
https://zkrisj.github.io/vitepress-blog/posts/native-substitution-for-jquery.html
https://www.cnblogs.com/moqiutao/p/9991678.html
 
## scss 转 css, 并且压缩
sass style.scss  style.css
sass style.scss style-min.css --style compressed

## webpack合并 css和js 到bundle.js
https://www.javascriptcn.com/post/66561bfbd3423812e4abfbb4
https://www.cnblogs.com/star2021/p/14392261.html
pnpm add -D webpack webpack-cli uglifyjs-webpack-plugin
pnpm add -D style-loader css-loader
```
