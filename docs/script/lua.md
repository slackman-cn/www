---
title: Lua Script
since: 202503
---

## Install

```
$ yum install lua
$ sudo apt install lua5.3
/usr/bin/lua
/usr/bin/luac

$ lua -v
$ lua
print(1+1)

$ ldd /usr/local/bin/lua
        linux-vdso.so.1 (0x00007fff2eb34000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f83d3087000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f83d2e5e000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f83d31b9000)
```

<https://www.lua.org/ftp/lua-5.4.7.tar.gz>
```
yum install @development
yum install readline-devel ncurses-devel
sudo apt install build-essential cpp make binutils

$ make linux
$ make test
$ make install  
// make install local
// make install INSTALL_TOP=/opt/lua
make
make install        安装到 /usr/local
make install local  安装到 ./install

编译结果  /usr/local/{bin,include,lib,man}
TO_BIN= lua luac
TO_INC= lua.h luaconf.h lualib.h lauxlib.h lua.hpp
TO_LIB= liblua.a
TO_MAN= lua.1 luac.1

==== 静态编译 (alma报错, arch成功)
$ vim src/Makefile
MYLDFLAGS=-static
```


## Lua 语法

```
区分大小写

```

## 执行系统命令

```
Lua有两种执行系统命令的方法：os.execute, io.popen

os.execute 返回的是命令执行的状态，一共返回3个值。
第一个值是true或nil, true表示命令成功执行完，否则返回nil。
第二个值是exit时，表示正常终止，第三个值表示退出的状态码。
第二个值是signal时，表示信号终止，第三个值表示终止的信号。

> os.execute("pwd")
true exit 0
> os.execute("pwdx")
nil exit 127

io.popen 启动一个新进程执行命令，并返回一个文件句柄，可以使用该文件句柄读取返回的数据。
例如,或通过这个方法获得文件列表
local f = io.popen("ls")
print(f:read("*a"))
```


## 自定义模块 function

```
LOG = require('log')
print(LOG)
LOG()

------- 导出函数 log.lua
local function log(self)
    print('hello log')
end

return log
```

## 自定义模块 object

```
logging = require('logging')
logging.msg()

local logger = logging.file("test%s.log", "%Y-%m-%d")


5.2 版本之后，require 不再定义全局变量，需要保存其返回值。
$ require "luasql.mysql"
需要写成:
$ luasql = require "luasql.mysql"

------- 导出对象 logging.lua
local logging =  {}
logging._VERSION = "1.0"

function logging.msg()
    print('hello logging: ', logging._VERSION)
end

if _VERSION < 'Lua 5.2' then
    _G.logging = logging
end

return logging
```


加载路径
```
export LUA_PATH=$PWD/scripts/
export LUA_PATH='/opt/lua;;'    # 原来的默认路径，里面没用文件


lua: ./hello.lua:5: module 'logging' not found:
        no field package.preload['logging']
        no file '/usr/local/share/lua/5.4/logging.lua'
        no file '/usr/local/share/lua/5.4/logging/init.lua'
        no file '/usr/local/lib/lua/5.4/logging.lua'
        no file '/usr/local/lib/lua/5.4/logging/init.lua'
        no file './logging.lua'
        no file './logging/init.lua'
        no file '/usr/local/lib/lua/5.4/logging.so'
        no file '/usr/local/lib/lua/5.4/loadall.so'
        no file './logging.so'
stack traceback:
        [C]: in function 'require'
        ./hello.lua:5: in main chunk
        [C]: in ?

root@a09a0cb548d3:~# export LUA_PATH=/opt/lua
root@a09a0cb548d3:~# ./hello.lua
hello
lua: ./hello.lua:5: module 'logging' not found:
        no field package.preload['logging']
        no file '/opt/lua'
        no file '/usr/local/lib/lua/5.4/logging.so'
        no file '/usr/local/lib/lua/5.4/loadall.so'
        no file './logging.so'
stack traceback:
        [C]: in function 'require'
        ./hello.lua:5: in main chunk
        [C]: in ?
```


# About Links

<https://forkful.ai/zh/lua/files-and-io/creating-a-temporary-file/>

__LOG__

<https://codeberg.org/imo/log.lua>

<https://github.com/lunarmodules/lualogging.git>

__Exec__

<https://forkful.ai/zh/lua/files-and-io/creating-a-temporary-file/>

<https://luabyexample.techplexlabs.com/execing-processes/>

<https://github.com/GUI/lua-shell-games.git>