---
title: 构建工具 ninja
since: 202503
---

## Install

https://mirrors.tuna.tsinghua.edu.cn/help/pypi/
```
sudo apt install build-essential
sudo apt install python3-venv

python3 -m venv vbuild
$ pip list
Package    Version
---------- -------
pip        22.0.2
setuptools 59.6.0
```

https://github.com/ninja-build/ninja.git
```
sudo apt install ninja-build
/usr/bin/ninja --version

pip install ninja
```

```
sudo apt install meson (require ninja-build)
/usr/bin/meson --version

pip install meson ninja
```

## Start

```
mkdir hello && cd hello
meson init

方式1
meson build
cd build && ninja && sudo ninja install

方式2
meson setup b2
meson compile -C b2
```

其他选项
```
/home/hello
meson setup build --prefix=$PWD/highgo -Dcassert=true '-DPG_TEST_EXTRA=kerberos ldap' -Dbuildtype=debug
ninja 
ninja install
创建目录 /home/hello/dist/bin/hello


cd build 
ninja test  或者 meson test
```

## Library

```
├── meson.build
└── src
    ├── gmath.c
    └── gmath.h


# meson.build
static_library('gmath', 'src/gmath.c'
  install: true)
```


# About Links

<https://www.cnblogs.com/RioTian/p/17984286>

<https://kernel-zhang.github.io/posts/MesonTutorial/>