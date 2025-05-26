---
title: Python Lib
since: 202503
---


## Install

https://www.python.org/ftp/python/

https://mirrors.aliyun.com/python-release/

```
C:\Users\Administrator>python -V
Python 3.9.13

C:\Users\Administrator>pip list
Package    Version
---------- -------
pip        22.0.4
setuptools 58.1.0


pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
Writing to C:\Users\Administrator\AppData\Roaming\pip\pip.ini
```

PyCharm Community
```
(venv) D:\Backup\Documents\GitHub\pycode>pip list
Package    Version
---------- -------
pip        21.3.1 
setuptools 60.2.0 
wheel      0.37.1 
```

## Install (Source)

```
pacman -S python-pip
yum install python3-pip
sudo apt install python3.11-venv

$ python3 --version
$ python3 -m venv vbuild

pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
```

https://docs.posit.co/resources/install-python-source.html
```
yum builddep python3 // 报错
yum install @development
yum install wget yum-utils openssl-devel bzip2-devel libffi-devel zlib-devel

$ ./configure --prefix=/opt/python3 
$ make -j8
$ make install
```

https://www.build-python-from-source.com/
```
cd /tmp/
wget https://www.python.org/ftp/python/3.13.2/Python-3.13.2.tgz
tar xzf Python-3.13.2.tgz
cd Python-3.13.2

sudo ./configure --prefix=/opt/python/3.13.2/ --enable-optimizations --with-lto --with-computed-gotos --with-system-ffi
sudo make -j "$(nproc)"
sudo make altinstall
sudo rm /tmp/Python-3.13.2.tgz
```

## wheel (poetry)

pip install poetry 很多依赖

https://python-poetry.org/docs/basic-usage/

https://pyloong.github.io/pythonic-project-guidelines/guidelines/project_management/distribution/#221
```
$ poetry new lfs
$ poetry build

$ vi lfs/__init__.py
def hello():
    print("This is a test code.")

测试安装
python -m venv vtest
pip install dist/some-package.whl
>> import lfs
>> dir(lfs)
>> lfs.__path__
>> lfs.hello()
['/root/vtest/lib/python3.13/site-packages/lfs']

>> from lfs import hello
>> hello()
```

## wheel (setup)

pip install wheel setuptools 两个单包
```
$ mkdir -p project/lfs && cd project 

$ python setup.py bdist_wheel
$ python setup.py sdist
python setup.py bdist_wheel --universal  生成 py2.py3-none-any.whl
打包结果在project/dist/lfs-1.0-py3-none-any.whl
解压 unzip some-package.whl
解压 wheel unpack some-package.whl
{dist}-{version}(-{build})?-{python}-{abi}-{platform}.whl

参考
https://docs.pingcode.com/baike/782958
https://realpython.com/python-wheels/
```

project/setup.py
```
from setuptools import setup,find_packages

setup(
    name="lfs",
    author="slackman",
    version="1.0",
    author_email="r@e.com",
    description="slackman@disroot.org",
    long_description="long desc",
    license='Apache2.0',
    packages=['lfs']  # 重要:这是python项目文件夹的名字
)
```

详细配置 https://www.cnblogs.com/wztshine/p/16421459.html
```
import setuptools

setup(
    name="lfs",  
    version="1.0",  
    author="slackman",  
    author_email="slackman@disroot.org",  
    description="A pipmodule package",  # 简短的描述
    long_description="long desc",  # 详细描述
    packages=find_packages(),  # 自动查找所有__init__.py
    url="https://www.slackman.cn",  

    classifiers=[
        "Development Status :: 3 - Alpha",  # 项目开发阶段
        "Programming Language :: Python :: 3",  # 编程语言
        "License :: OSI Approved :: MIT License",  # license
        "Operating System :: OS Independent",  # 操作系统
    ],

    install_requires=[
        "progress",
        # "pytest>=3.3.1",  # 也可以出依赖的具体版本
    ],
    python_requires=">=3" 
)
```


## Console APP

第三方模块 click,typer
```
import click
import typer  基于click
```

内置模块 sys, argparse
```
import sys

def main():
    if len(sys.argv) < 2:
        print("Usage: python console.py <name>")
        sys.exit(1)
    name = sys.argv[1]
    print(f'Hello, {name}')

if __name__ == '__main__':
    cli()
```

> python xxx.py Tom  |  python xxx.py Tom --times 3
```
import argparse

def cli():
    parser = argparse.ArgumentParser(description="Greet someone by name.")
    parser.add_argument("name", help='The name of person to greet.')
    parser.add_argument("--times", type=int, default=1, help="Number of times to greet")

    args = parser.parse_args()
    for _ in range(args.times):
        print(f'Hello, {args.name}!')
```


## Desktop APP

Tkinter 模块(Tk 接口)是 Python 的标准 Tk GUI 工具包的接口 .Tk 和 Tkinter 可以在大多数的 Unix 平台下使用,同样可以应用在 Windows 和 Macintosh 系统里。Tk8.0 的后续版本可以实现本地窗口风格,并良好地运行在绝大多数平台中。

wxPython 是一款开源软件，是 Python 语言的一套优秀的 GUI 图形库，允许 Python 程序员很方便的创建完整的、功能健全的 GUI 用户界面。

Jython 程序可以和 Java 无缝集成。除了一些标准模块，Jython 使用 Java 的模块。Jython 几乎拥有标准的Python 中不依赖于 C 语言的全部模块。比如，Jython 的用户界面将使用 Swing，AWT或者 SWT。Jython 可以被动态或静态地编译成 Java 字节码。