---
title: Wiki.js
since: 202412
about: https://js.wiki/
---

# Wiki.js 创建网站

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


## 自定义

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