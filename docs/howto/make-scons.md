---
title: 构建工具 scons
since: 202503
---

## Install 

```
sudo apt-get install scons

$ python -m venv vbuild
$ pip install scons
$ scons --version

没有其他依赖
(vbuild) [root@archiso ~]# pip list
Package Version
------- -------
pip     24.3.1
SCons   4.8.1
```

Source Install
```
方式1
SCons-4.8.1.tar.gz
$ pip install wheel setuptools
$ python setup.py bdist_wheel
$ pip install build/dist/SCons-4.8.1-py3-none-any.whl
python setup.py install #有点问题

方式2
scons-local-4.8.1.tar.gz
python /path/to/unpacked/scripts/scons.py --version
```


## Start

make -s, --silent, --quiet   Don't echo recipes
```
$ scons
$ scons --clean;  scons -c
$ ./hello
减少输出
$ scons -Q

==== SConstruct 单文件
print('xxx')
Program('hello.c')
Program('new_hello', 'hello.c')
Object('hello.c')

==== hello.c
#include <stdio.h>
int main()
{
   printf("Hello, world!\n");
}
```

SConstruct 多文件
```
Program('program', ['prog.c', 'file1.c', 'file2.c'])
Program('program', Glob('*.c'))
Program('program', Split('main.c file1.c file2.c'))

src_files = Split('main.c file1.c file2.c')
Program(target='program', source=src_files)
```

## Library

SConstruct 默认静态库
```
Library('foo', ['f1.c', 'f2.c', 'f3.c'])
StaticLibrary('foo', ['f1.c', 'f2.c', 'f3.c'])
StaticLibrary('foo', ['f1.c', 'f2.c', 'f3.c'])

Library('foo', ['f1.c', 'f2.c', 'f3.c'])
Program('prog.c', LIBS='foo', LIBPATH='.')   等价 LIBS=['foo']
Program('prog.c', LIBS=['foo', 'bar'], LIBPATH='.')

系统库
Program('prog.c', LIBS = 'm',
                  LIBPATH = ['/usr/lib', '/usr/local/lib'])
```

SConstruct ENV
```
env=Environment(VAR="value")
n=File("foo.c")
print(env.GetBuildPath([n, "sub/dir/$VAR"]))

env = Environment()
conf = Configure(env)
# Checks for libraries, header files, etc. go here!
env = conf.Finish()

hello = env.Program('hello.c')
env.Install('/usr/bin', hello)
```


# About Links


<https://scons.org/pages/download.html>

<https://scons.org/doc/production/HTML/scons-user.html>

__Demos__

https://wiki.lckfb.com/zh-hans/hspi-d133ebs/rtos-sdk/user-guide/sconstruct.html

https://github.com/bobwenstudy/scons_demo

https://www.scons.org/doc/0.92/HTML/scons-user/c108.html

__Python Version__  3.11 security; 3.12 bugfix

<https://devguide.python.org/versions/>
