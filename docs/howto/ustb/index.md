---
title: USTB
since: 202412
---

## USTB

```
大一：高等数学、C/C++、离散数学
大二：计算机组成原理、数字电路、数据结构、线性代数
大三：编译原理、操作系统、模拟电路、网络原理、汇编相关课程、概率论


要自学计算机专业课的话，一般先学C语言（系统编程的基础，最经典的过程式程序设计语言）和离散数学（计算机科学的数学基础）；
然后学习数据结构（所有专业课的基础）和计算机系统基础（这其中包括汇编）；

。模拟电路和计算机专业知识几乎没有任何关系，自学的话不建议学

数字电路-组成原理是一条线，操作系统是一条线，计网是一条线，编译是一条线，算法是一条线，C++等面向对象语言是一条线，这些不分先后都可以按需学习
```

功能，可靠性，可用性，效率

可维护，可移植，兼容性(Compatibility)
```
功能是否完备, 是软件质量的核心,正确地执行所需的功能
在一定时间内能够持续正常地运行
易于使用
消耗的资源量，包括时间、内存和磁盘空间等

--->
容易维护和修改
容易在不同的平台上运行
能够与其他软件和硬件兼容
```



### 架构设计原则

编程第一原则：先把东西做出来
```
* 代码要可读

● 要有注释，但不能太多，单行注释足够了 #xxx
● 网络不安全，所以不会滚动更新
● 时间效率，高于空间效率
● 没有包管理器，每个软件都是一体的，和依赖要在一起
● 库很重要， 和flatpack一样默认没有任何仓库，有一个中央仓库，可以自建，可以用git/svn管理
● 约定大于配置, spec描述文件
● 变量小写，常量大写
● 必须有输出   bin/   lib/  ScriptSpec  Specfile
● 数据和类型一体，不可分割
```

指令系统 8类
```
A算数arithmetic,B逻辑bit,C控制control  => ALU
U字符unicode,V向量vector,G图连接graph
X,Y 扩展，动态引擎，运行时引擎 java,js,gui,axv多媒体
```

表示数据
```
表示数字  0xFF  8bit   或 0xFFFF 16bit
表示字符串  u'asdf'  或 'adsf'  不要双引号
int num = 'a'  这是一个ASCII编码
```

标准库
```
 c语言  #include <stdint.h>   c++11  #include <cstdint>
https://www.runoob.com/cplusplus/cpp-libs-cstdint.html
// 声明固定宽度的整数类型
int8_t a = -128; // 最小值
uint8_t b = 255; // 最大值
int16_t c = -32768;
uint16_t d = 65535;
int32_t e = -2147483648;
uint32_t f = 4294967295U; // 使用 U 后缀表示无符号常量
int64_t g = -9223372036854775807LL; // 使用 LL 后缀表示长长整型常量
uint64_t h = 18446744073709551615ULL; // 使用 ULL 后缀表示无符号长长整型常量

INT8_MIN, INT8_MAX, UINT8_MAX
INT16_MIN, INT16_MAX, UINT16_MAX
INT32_MIN, INT32_MAX, UINT32_MAX
INT64_MIN, INT64_MAX, UINT64_MAX
```

### 仓库/模块/包

一切皆文件
```
include包含, 没有包管理器, 只有文件和目录 两种东西
没有 module /require/ import /namespace之类的东西，每个文件就是一个模块(不声明module)
include "xxx.tsc"  引入所有， 隐式模块
include "xxx"   引入 xxx/* ，   显式模块
```

```
目录可以包含任意文件 xxx/
VERSION
VERSION.tsc

相对位置，不能只导入一部分，文件文件无法分割
#include "VERSION"
#include "VERSION.rst"
util = include("util.tsc")
util = include "util.tsc"

# 入口可以任意文件名
index, main, index.tsc, __init__

# 描述文件Specfile,  有约定和约束
不使用json,xml 使用自己的脚本语言
XXX = Specification()
XXX::Specification
env: bash
```

### 类型系统独立

```
使用protoc兼容
type +  c-like/c-link  + assembly
类型(auto), 函数, 结构体, 模块
注释#  多条语句;  行尾可以加也可以不加
```

方案1
```
常量
A = 10
PI = 3.12
NUL

变量
a = 10; b = "eee"
a = int     是类型，也是初值
a = int(10) 是类型，也是函数
b = bytes

语句块函数块，是否等价; 不等价，函数全局，为了复用
语句块可以加{}也可以不加，缩进足够了; 函数只能用关键字声明
if TRUE
  ...
else if TRUE
  ...
else
  ...

输出到控制台
message("lll ${name}, ls {:name}")
message("lll ${name}, ls {:name}", ctx)

返回状态码 OK, exitCode
def add(a,b, out c)
  c = a + b
enf
a = 10; b = 20
c 
add(a,b,c)

C语言没有异常处理，只处理error
def add(a=int, b=bytes, out c=int)
  return  //什么都不返回，终止
  exit("asdf") 错误信息
  exit(-2)     错误码
enf

特殊指令
#!/bin/bash
include "xxx"
```

方案2
```
fn = add(a,b,c) // return Function Type
fn.params
fn.args
fn.value // return  不throw new Error("asdf")除了OK，全是异常
fn.result
if (fn == NUL)  重写运算符，比较 fn.value == NUL

结构体类型
typedef Stu(int,bytes) // 没有string，本质是bytes
ss = Stu(10, "adf3")   
ss = Stu
ss[0]
ss[1]

结构体类型2
typedef Stu(id = int, name = bytes)
ss = Stu(10,"ss")  声明 + 赋值
ss = Stu  				 声明 + 初值
ss.name
ss.id


值类型value, return Value Type; rename type
typedef Stu = int
ss = Stu(10)  // 等价 ss = int(10) 
ss = Stu  	  // 等价 ss = int
ss = 10

元组类型 Tuple, Array
typedef Stu = [int,bytes]
ss = Stu([10, "www"])
ss = Stu
ss = [10, "234"]  // return Array Type
ss[0]
ss[1]


初始化函数
typedef Stu(id = int, name = bytes)
  $id++
endf
```

属性顺序最重要，为了序列化;  有构造，没有析构
```
值类型
typedef Person = int
typedef Person::id = int

基础类型
typedef Person(id = int, name=bytes)  
enf
typedef Person
  id = int
  name = bytes
enf
p = Person;  p.id = 12; p.name = "asdf"
p = Person {
  id = 32  # 属性初始化
  name = "asdf
}
p = Person(12)
p = Person(12, "asdf")

继承有用吗，为了少写几个属性，还是为了继承方法
typedef Student
  id = int     # 优先级最高，解释型就是这样，先定义先使用
  name = bytes # 显示类型会覆盖隐式类型，就像maven依赖一样
  ::Person   # 所有Person属性
  ::Person2  # 所有Person2属性
  Person::   # 所有Person属性, 这个比较好
  Person::*
  Person::{id,name}
  
enf
s = Student(10, n)
```

方案3
```
fn = add(a,b,c) // return Function Type
fn.params
fn.args
fn.value // return  不throw new Error("asdf")除了OK，全是异常
fn.result
if (fn == NUL)  重写运算符，比较 fn.value == NUL

结构体类型
typedef Stu(int,bytes) // 没有string，本质是bytes
ss = Stu(10, "adf3")   
ss = Stu
ss[0]
ss[1]

结构体类型2
typedef Stu(id = int, name = bytes)
ss = Stu(10,"ss")  声明 + 赋值
ss = Stu  				 声明 + 初值
ss.name
ss.id


值类型value, return Value Type; rename type
typedef Stu = int
ss = Stu(10)  // 等价 ss = int(10) 
ss = Stu  	  // 等价 ss = int
ss = 10

元组类型 Tuple, Array
typedef Stu = [int,bytes]
ss = Stu([10, "www"])
ss = Stu
ss = [10, "234"]  // return Array Type
ss[0]
ss[1]


初始化函数
typedef Stu(id = int, name = bytes)
  $id++
endf


废弃
ss: Stu = 10
typedef Stu(id: int, name: bytes)
```


##  8421 BCD编码

```
2 + 3 = 0010 + 0011 = 0101 = 5  ; 结果<=9 正常
2 + 9 = 0010 + 1001 = 1011    ; 结果 >9, 修正结果+6  1000/0001 = 11
```

2421 编码
```
0000 -> 0
0001 -> 1
0010 -> 2
0011 -> 3=2+1
0100 -> 4

1011 -> 5=2+0+2+1
1100 -> 6=2+4
1101 -> 7=2+4+0+1
1110 -> 8=2+4+2+0
1111 -> 9=2+4+2+1
```



## 字符编码 （unicode）

<https://wuli.wiki/online/encode.html>  
<https://www.cnblogs.com/xtuz/p/12448200.html>  

```
NUL 字符是 ascii 表中编号为 0 的字符，也就是说在该子节中，所有的比特都为零
NUL 字符通常用于 C 语言的字符串的最后代表字符串结束，但几乎不用于文本文件中（无论使用哪种编码）

> ASCII 编码，每个字符占据1bytes
用二进制表示的话最高位必须为0（扩展的ASCII不在考虑范围内），因此ASCII只能表示128个字
目前世界上除ASCII之外的其它通行的字符编码方案，基本上都兼容ASCII，但相互之间并不兼容

> ANSI编码，表示英文字符时用一个字节，表示中文用两个字节
遇到字节是以0开头的，就知道这一个字节就表示了一个字符；遇到字节是以1开头的，就知道要加上下一个字节合起来表示一个字符
必须是两个大于127的字节连在一起来共同表示一个汉字(GB2312为双字节编码)，前一字节称为高字节，后一字节称为低字节
在GB2312中收录了6763个汉字以及682个特殊符号，已经囊括了生活中最常用的所有汉字
简体中文系统下，ANSI 编码可以是 GB2312 或者 GBK 编码，在日文操作系统下 ANSI 编码代表 JIS 编码

> Unicode 编码，ISO规定每个字符必须使用两个字节
对于ASCII编码表里的字符，保持其编码不变，只是将长度扩展到了16位，其他国家的字符全部统一重新编码
```

|  中文字符   | ANSI(GBK)  |  Unicode   | UTF-8  |
|  ----  | ----  |  ----  | ----  |
| 中    | 0xD6D0 | 0x4E2D  | 0xE4B8AD |

字/半字
```
数据总线16bit, 32bit, 64bit
32 位系统，字 = 32bit = 4byte
64 位系统，字 = 64bit = 8byte
龙芯 bit b,   Byte B,    Word W 32b,   Halfword H 16b,    Doubleword D 64b
```


## NASM 和 C

FC/NES 用 6505汇编NESASM,  GBA开始用C 32bit。FC的资料比GBK多

NES好理解 <https://happysoul.github.io/nes/asm_cn/>
```
直接控制硬件，图形，声音，输入输出
ROM, RAM
PRG / Program Memory   / code of game  / ROM
CHR / Character Memory / data of graphisc / RAM or ROM
CPU, Picture PU, Audio PU
```

现在绝大部分单片机都用C，公司不要求汇编

单片机 <http://www.51hei.com/bbs/dpj-227533-1.html>

汇编   <https://cs.lmu.edu/~ray/notes/nasmtutorial/>
```
sudo apt install nasm
nasm --help

sudo apt install sasm  非常难用
sudo apt install gcc-multilib  会重启所有服务
IDE

nasm -felf64 hello.asm && ld hello.o && ./a.out
```


## GTK 和 Qt

<https://www.kancloud.cn/apachecn/zetcode-zh/1950323>  
<https://developer.aliyun.com/article/1245602>  
<https://notes.leconiot.com/gtk.html> 
```
$sudo apt-get install libgtk-3-dev
$sudo apt-get source libgtk-3-dev

$sudo apt-get install automake
$./configure --prefix=/opt/gtk3
$make
$make install
```



## 编程也是编码

编程与编码，都是二进制;  bin 目录，bin文件，二进制Binary；asci 编码, u8编码
```

代码段 .text   指令流code
数据点 .data   数据流data

指令 + 变量 + 控制流
code 指令，ByteCode 字节码
data 数据，bytes = (string = byte[])
```


## 函数也是命令

```
Exit Status
Return Value

shell buildin 内建命令
type cd 

type -a echo 外部命令
/usr/bin/echo
```

## Stack Based Machine

```
栈机用内存，寄存器用CPU。 以后内存会越来越快
基于栈的优点是可移植性更好、指令更短、实现起来简单，但不能随机访问栈中的元素，完成相同功能所需要的指令数也比寄存器的要多，需要频繁的入栈和出栈。
基于寄存器的优点是速度快，有利于程序运行速度的优化，但操作数需要显式指定，指令也比较长。

关键点
* 栈机，龙芯指令 2^7 用ASCII编码 （参考JVM指令集）
https://javabetter.cn/jvm/zijiema-zhiling.html
* 指令和数据分离，数据是根本，计算机本质是数据，算法本质是指令。
* 兼容性有限，必要的程序换一个java native env环境运行，或者用C写，用汇编写
* SQL存储过程
* 类型是必要的，默认只有 Number 和 Text,  常量, 标准SQL类型 推断
https://www.runoob.com/sql/sql-datatypes-general.html
* 引入其他类型stdlib.h   java.h
```

cpuid 十进制计算机
ABCDEF 表示指令, 0123456789 表示数据
```
模拟 8bit   计算器。先用软件实现Qt, Java
物理 64bit 计算机。二进制编码，存储系统，指令系统

VT 两种模式
V全模拟全APP，与 Runtime 绑定
T高性能单APP，与 Runtime 分离
```

网络计算机，时间必须同步
```
Linux 内核
GNU 工具
Linux 桌面环境
应用软件
> 发行版 LiveCD
```


## Lua Based Language

https://www.lua.org/versions.html
```
[openEuler]
yum install -y gcc
[anolis]
yum install -y gcc make


## lua 5.3依赖  (5.4不依赖)
yum install -y readline-devel

## 
readline 是基础库,openeuler和anolis都有

## 教程:写一个编程语言
Building a Programming Language
https://classpert.com/classpertx/courses/building-a-programming-language/cohort
```

函数有返回值, 过程没有
```
typedef xxx
  return 10
enf
aa = xxx()  // aa = 10
if (aa != nil) ...
if (aa) ...

https://c-cpp.com/c/program/EXIT_status.html
没有返回值,  本质是 int main(void) 只返回执行状态
def yyy
  return 10
  exit(1);
  exit(EXIT_FAILURE);
  return EXIT_SUCCESS;
enf
aa = xxx() // aa = FunctionReturn{exitCode, retValue,}  {error,value)
aa.value   // 类似Optional<int> 
if (aa) 
```

ExitCode
```
System.exit(int status)

C语言 <stdlib.h>
EXIT_SUCCESS  或为零
EXIT_FAILURE

OK 0
WARN 5
ERROR 10
FAILURE 20

    0: Success—Indicates that the command or program executed successfully without any errors.
    1: General Error—A catch-all exit code for a variety of general errors. Often used when the command or program encounters an error, but no specific exit code is available for the situation.
    2: Misuse of shell built-ins—Indicates incorrect usage of shell built-in commands or misuse of shell syntax.
    126: Command cannot execute—The command was found, but it could not be executed, possibly due to insufficient permissions or other issues.
    127: Command not found—The command was not found in the system's PATH, indicating that either the command does not exist or the PATH variable is incorrectly set.
    128: Invalid exit argument—Returned when a script exits with an invalid argument. This usually indicates an error in the script itself.
    128 + N: Fatal error signal N—Indicates that the command or program was terminated by a fatal error signal. For example, an exit code of 137 (128 + 9) means that the command was terminated by a SIGKILL signal.
    130: Script terminated by Control-C—Indicates that the command or script was terminated by the user using Control-C (SIGINT signal).
    255: Exit status out of range—Returned when the exit status is outside the valid range (0 to 254).
```

关键字 Keyworkd (尽量生僻一点，不要让所有人避讳)
```
def      / enf
typedef  / enf

call,  syscall
exec aaaa  /  aaaa()

------
函数是头等公民，为了区分代码块，不适用 { } 或者 begin/end  do/end 包围函数体
第一行是声明，格式固定  或者到 (参数结尾)
def aaa
enf
def a2(aaa)
def a3(p1,p2
        ,p3)

------ 函数也是类型，可以作为参数 
函数实际名称
def aaa  ==>  aaa, aaa_*
def aaa()  ==> aaa, aaa_0
def aaa(p1,p2)  => aaa_2
def aaa(.number p1, .number p2)  =>  aaa_2_i_i

(.number p1  .string p2  .exec aaa)  名称只是为了捕获传参
_i
_f  // float 还是 function 有歧义

-------- 函数内声明子函数
sub marine {
    $n += 1;  # Global variable $n
    print "Hello, sailor number $n!\n";
}

f1(a,b) = {}

[function] f1(aa, bb) {
  
}

f1()
```

编译脚本 执行./build.sh  类似 gradle (build.bat  和  build)
```
spec: v1.2  // 规范（cmake最低版本）
name: xxxx

project = xxxx
version = v1.2
source  = ./src
target  = ./dist

set(X2_VERSION)  // 内置全局变量，内置函数
set(CC = '')  //全局变量，源码使用 $CC获取
set(GCC = '')
set(CXX = '')

// default value, gcc
clink('system dir') { 
  include <aaa.h>
  -lpng
  -lm
}

set(JAVA_HOME='')
set(JAVAC = '')
set(JAVA  = '')

// default value, jdk
jlink('mavem repo') {  
  import "net.aaa.bb:cc:1.2"
}
```

作用域 do...end
```

-------- lua
do
  local a2 = 2*a
  local d = sqrt(b^2 - 4*a*c)
  x1 = (-b + d)/a2
  x2 = (-b - d)/a2
end          -- scope of `a2' and `d' ends here
print(x1, x2)


https://www.runoob.com/linux/linux-shell-process-control.html

--------- shell
if condition1
then
    command1
elif condition2 
then 
    command2
else
    commandN
fi

for loop in 1 2 3 4 5
do
    echo "The value is: $loop"
done
```