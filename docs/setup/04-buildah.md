---
title: Buildah
since: 202503
---


## 封装系统环境

ubuntu => ubuntu-devel
```
https://docker.aityp.com/image/docker.io/ubuntu:22.04
swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/ubuntu:22.04
swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/ubuntu:22.04-linuxarm64

buildah containers
buildah images

buildah from anolis  // anolis-working-container
buildah from --name builder anolis
删除容器(不需要关闭)
buildah rm  $containername
使用修改后的容器创建镜像
buildah commit builder anolis-devel

podman run -it --rm --privileged ubuntu-devel
podman run -td --name build --privileged -v `pwd`:/build anolis
podman exec -it build bash
```

## Ubuntu22

https://developer.aliyun.com/mirror/ubuntu
```
buildah from --name builder ubuntu
buildah config --env LANG=en_US.UTF8 builder
buildah config --env LC_ALL=en_US.UTF8 builder
buildah config --env LANGUAGE=enUS:en builder

buildah copy builder sources.list /etc/apt/

buildah run builder apt update
buildah run builder apt install language-pack-en  
buildah run builder apt install build-essential
buildah run builder apt install vim less git wget curl

buildah commit builder ubuntu-devel
```

sources.list
```
====== Ubuntu22 x86
deb http://archive.ubuntu.com/ubuntu jammy main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu jammy-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu jammy-updates main restricted universe multiverse

cat << EOF > sources.list
deb http://192.168.1.1:8081/repository/ubuntu/ jammy main restricted universe multiverse
deb http://192.168.1.1:8081/repository/ubuntu/ jammy-security main restricted universe multiverse
deb http://192.168.1.1:8081/repository/ubuntu/ jammy-updates main restricted universe multiverse
EOF


====== Ubuntu22 ARM
deb http://ports.ubuntu.com/ubuntu-ports/ jammy main restricted universe multiverse
deb http://ports.ubuntu.com/ubuntu-ports/ jammy-security main restricted universe multiverse
deb http://ports.ubuntu.com/ubuntu-ports/ jammy-updates main restricted universe multiverse

cat << EOF > sources.list
deb http://192.168.1.1:8081/repository/ubuntu-ports/ jammy main restricted universe multiverse
deb http://192.168.1.1:8081/repository/ubuntu-ports/ jammy-security main restricted universe multiverse
deb http://192.168.1.1:8081/repository/ubuntu-ports/ jammy-updates main restricted universe multiverse
EOF
```


## Anolis

https://mirrors.openanolis.cn/anolis/8.9/isos/GA/x86_64/
```
buildah from --name builder anolis
buildah config --env LANG=en_US.UTF8 builder
buildah config --env LC_ALL=en_US.UTF8 builder
rpm -qa | grep glibc-langpack
buildah run builder yum install glibc-langpack-zh -y
buildah run builder yum install glibc-langpack-en -y
buildah run builder yum install vim less git wget curl -y
buildah run builder yum groupinstall "Development Tools" -y
buildah run builder yum install rpmdevtools -y

buildah commit builder anolis-devel
```

## openEuler

https://repo.openeuler.org/openEuler-22.03-LTS-SP4/docker_img/x86_64/

https://mirrors.tuna.tsinghua.edu.cn/openeuler/openEuler-22.03-LTS-SP4/

```
buildah from --name builder openeuler
buildah config --env LANG=en_US.UTF8 builder
buildah config --env LC_ALL=en_US.UTF8 builder
openeuler需要安装
buildah run builder glibc-locale-archive -y  
buildah run builder yum install vim less git wget curl -y
buildah run builder yum groupinstall "Development Tools" -y
buildah run builder yum install rpmdevtools -y

buildah commit builder openeuler-devel
```