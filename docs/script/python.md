---
title: Python Script
since: 202503
---

## Install

```
pacman -S python-pip
yum install python3-pip
sudo apt install python3-venv

$ python3 --version
$ python3 -m venv vbuild

pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
```

## Python 语法

func
```
def print_hi(name):
    print(f'Hi, {name}') 
    print('hello, ' + name)

if __name__ == '__main__':
    print_hi('PyCharm')
```

vars
```
len('asdfa')
int('123'), float, bool, str(1234)
ii = None
type(ii)
3 / 2  结果1.5
3 //2  结果1  向下取整

if True:
  pass
elif a == 10 or a == 11:   # and,or,not
  pass
else:
  pass
```

## 字典, 列表, 循环

```
mylist = [1,2,3]
mylist.append(4)
len(list)

mydict = {}
mydict = {'name': 'xiao', 'age': 12}
mydict['name'] = 'xiao2'
len(mydict)   # 键值对
'name' in mydict
del mydict['name']

mytuple = ('aa', 'bb')  # 不可变

===== 循环
for v in mylist:
  pass
for k,v in mydict.items():  # 键值对
  pass
for in in range(1,10):    # 不包括10  (1,10,2)步长2
  pass

mydict.keys()
mydict.values()
mydict.items()  
```

## 函数, 面向对象

```
class ATM:
   def __init__(self, id, name):
      self.id = id
      self.name = name

   def show(self):
       print(self.id, self.name)

a1 = ATM('01', 'xiao')
a1.show()
print(a1.name)


class SubATM(ATM):   # 继承
   def show(self):
      pass

```

## 模块, 异常

```
https://docs.python.org/zh-cn/3/library/math.html
import math
math.sin(1)

标准库 https://docs.python.org/zh-cn/3/libray/index.html
import xxx
xxx.函数
xxx.变量

from xxx import 变量,函数
from xxx import *
```

IO模块, 异常
```
with open('./aaa.txt', 'r', encoding='utf-8') as f:
   txt = f.read()  # 全部内容  read(10)只读取10字节
   row = f.readline()  # while判断 row != ''
   lines = f.readlines()
   for row in lines:
      pass

with open('./output.txt', 'w', encoding='utf-8') as f:
  #  模式w 清空, 模式a 追加,  模式r+ 读写追加
  f.write('hello\n')

try:
  xxx()
except ValueError:
  print(xxxx)
except:
  print('all error')
else:
  print('no error')
finally:
  print('程序结束')
```


## 单元测试

```
assert len('he') == 2  # 报错停止程序
$ python -m unittest

import unittest
from 文件名 import 函数名
from 文件名 import 类名


class MyTestCase(unittest.TestCase):
    def setUp(self):
	 self.xxx = 创建类

    def test_something(self):	      # 函数必须test_xxx
        self.assertEqual(True, False)  
        self.assertTrue(xxx)


if __name__ == '__main__':
    unittest.main()
```


# 100示例

加法
```
n1 = 10
n2 = input("number 2: ")
sum = n1 + float(n2)
print("加法: ", sum)
```

阶乘
```
count = 1
for i in range(1, 6):
    # count = count * i
    count *= i
print("阶乘5: ", count)
```

算法1: 不重复三位数

```
nums = [1,2,3,4]

for i in nums:
    for j in nums:
        for k in nums:
            if (i != j and i != k and j != k):
                print(i,j,k)
```

算法2: 判断闰年
```
def check(n):
    if n % 4 ==0 and n %100 !=0:
        return True
    if n % 400 == 0:
        return True
    return False

检查 print('2004', check(2004))
http://www.runnian.cc/runnianrunyue.aspx
```

算法3: Fib数列
```
def fib(n):
    if n == 1 or n == 2 :
        return 1
    return fib(n-1) + fib(n-2)

检查 0,1,1,2,3,5,8,13 ...
https://oi-wiki.org/math/combinatorics/fibonacci/

==== 方式1
a = 1
b = 1
for n in range(3,41):
    tmp = a+b
    a = b
    b = tmp
    print(f'fib({n}) = {b}')

==== 方式2
dp = [0,1,1]
for i in range(10):
    dp.append(dp[-1] + dp[-2])
```