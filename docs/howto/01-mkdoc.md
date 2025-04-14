---
title: MkDocs
since: 202412
about: https://www.mkdocs.org/
---

# MkDocs 创建网站

https://www.mkdocs.org/getting-started/
```
sudo apt install python3-venv
sudo apt install python3-pip

python3 -m venv mysite
source bin/activate
pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
pip install mkdocs

mkdocs new website
mkdocs serve
```

### 新增页面

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

### 主题

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

### 自定义样式 (Support IE8)

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

https://pure-css.github.io/    
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
