---
title: C,C++,LUA
since: 202503
---

## Install

```
sudo apt install build-essential cmake meson
sudo apt install crossbuild-essential-arm64
eclipse-cpp.tar.gz

>> GUI
sudo apt install qtcreator qtbase5-dev
sudo apt install libwxgtk3.2-dev codelbocks
```

## C 语法

typedef unsigned int ID;
```
struct Stu {
    成员
} 变量;

struct Stu {
	int id;
	char name[20];
	float score;
};
struct Stu s1,s2;
struct Stu s1 = {1, "xiao", 9.9};

typedef struct student {
	...
} Stu;
Stu s1;
```

`#define 标识符 常量`  没有分号
```
#define MAX_SIZE 20

数组
typedef struct {
	T data[MAX_SIZE];
	int length;
} SqList;

链表
typedef struct LNode {
	T data;
	struct LNode *next;
} LNode, *LinkList;

LNode *p;
LinkList p;
```

其他方式 struct
```
struct Stu {
	int id;
	char name[20];
	float score;
} s1, s2;

struct {
	int id;
	char name[20];
	float score;
} s1, s2;
```

## 内存分配

C 指针
```
int a = 10;
int *p = &a;

switch (a) {
    case 常量: 语句;
    default:  语句;
}

int *p;
p = (int*) malloc(sizeof(int));

free(p);

输入输出
int n;
scanf("%d", &n);

printf("hello\n")
```

C++ 内存分配
```
int *p = new int;
delete p;

引用
int n =10;
int& n2 = n;

输入输出
int n;
cin >> n;
count << "hello\n";
```


## 源码 Lua

```
yum install lua
/usr/bin/lua
/usr/bin/luac

$ lua -v
$ lua
print(1+1)
```

https://www.lua.org/ftp/lua-5.4.7.tar.gz
```
$ cd src
yum install @development
yum install readline-devel ncurses-devel
make -j8

或者 cd lua-5.4.7
make
make install 安装到 /usr/local
make local   安装到 ./install

==== 静态编译 (alma报错, arch成功)
$ vim src/Makefile
MYLDFLAGS=-static
```