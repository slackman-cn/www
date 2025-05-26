---
title: Ruby 
since: 202503
---

## Install

```
sudo apt install ruby ruby-dev ruby-bundler

root@ubuntu22:~# ruby --version
ruby 3.0.2p107 (2021-07-07 revision 0db68f0233) [x86_64-linux-gnu]

root@ubuntu22:~# bundler --version
Bundler version 2.3.5

===== 默认源
root@ubuntu22:~/ruby# gem sources
*** CURRENT SOURCES ***

https://rubygems.org/

===== 国内源
gem sources --remove https://rubygems.org/
gem sources -a https://mirrors.aliyun.com/rubygems/
```

source
```
RUBY_BUILD="v20250409"
RUBY_TAG="3.3.8"

# Install Ruby
apt-get install --yes \
   autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
git clone https://github.com/rbenv/ruby-build.git /build/ruby-build  --depth 1 -b "${RUBY_BUILD}"

PREFIX=/usr/local/ruby-build ./ruby-build/install.sh
ruby-build --list
ruby-build ${RUBY_TAG} /usr/local/ruby

$ ruby --version
ruby 3.3.8 (2025-04-09 revision b200bad6cd) [x86_64-linux]

$ bundle --version
Bundler version 2.5.22

$ rake --version
rake, version 13.1.0

$ gem list | wc -l
86
```

## HelloWorld

```
class Person
  # 静态变量
  @@cnt = 1

  # 属性，实例变量
  attr_accessor :name, :age

  # 初始化方法
  def initialize(name, age)
    @name = name
    @age = age
  end

  # 定义方法
  def greet
    "My name is #{@name} and I am #{@age} years old."
  end
end

person = Person.new("Alice", 30)
puts person.greet
```

## HelloWorld WEB (sinatra)

rails 非常复杂，不适合小项目
```
$ gem install sinatra
$ gem install rackup puma
$ ruby app.rb
$ curl localhost:4567
$ 静态文件从 ./public 目录提供服务
$ 文件 ./public/css/style.css 作为 http://example.com/css/style.css

======= touch app.rb
require 'sinatra'

get '/' do
  'Hello world!'
end
```

生产环境
```
$ bundle install
$ rackup  // 默认端口9292
$ rackup config.ru --port=8080

docker.image('ruby:2.6').withRun('-v $(pwd):/app -w /app') { c ->
    sh 'bundle install'
    sh 'rake test'
}

========= 创建 Gemfile
$ bundle init
$ bundle add sinatra
$ bundle add rackup puma

========= 创建 config.ru
require 'rubygems'
require 'bundler'
Bundler.require

require './app'
run Sinatra::Application

```


## Ruby 语法

```
print "Hello world!\n"
# 输出 p(”hee")
print("hello")
print("\n")
puts "hello"

# 数值对象，字符串对象，时间对象，文件对象，数组对象
# Numeric, String, Array, File
# 局部变量 aa, _aa   常量(readonly) TEST=1  RUBY_VERSION
# 全局变量 $x  实例变量@xx  类变量@@shape
arr = ["a", 2, nil]
arr.each do |item|
  p(item)
end
puts(RUBY_VERSION)
puts(RUBY_PLATFORM)
a=1
b=2;c=3
v=(a>b) ? a : b
puts(v)
# Range.new(1,10)  范围运算符1..10
# 指数**  三元?:
# 值相等 === ,  属于类 p(String === "asdf")
```


## 选择循环

```
# if xx then [] end 可以省略then, if xx then {} elsif then {} else {} end
# unless yy then {}  end  条件为假执行
if true
  puts("bb")
end

case v
  when 1 then
    puts("1")
  when 2 then
    puts("2")
  else
    puts("none")
end


# 循环 times方法, for语句, while, util, loop
# 用{}代替 do end
3.times do |i|
  puts("No. #{i}")
end
10.times { }
for i in 1..10 do
  #
end

arr = ["a", "b", "c", "d"]
for name in arr do
  #
end
arr.each do |name| puts name end

loop do
  # 死循环
  break # next等价continue, redo重复刚才处理
end
while true  do
  # 条件为真
end

until false do
  # 调价为假
end
```

## 函数
```
# 运算符也是方法，有些可以重载
# 实例方法
p "10,2,3".split(",")
p [12,3].index(1)
p 100.to_s  # 转字符串
# 类方法
Array.new
File.open("hello.rb", "r")
Time.now
# 函数方法
sleep(2)
print("hello world")

def hello(name)
  puts "Hello, #{name}"
end

def add(a,b)
  return a + b # 可以省略return
end

def fool(*args)
  # 个数不确定
  # 至少一个参数 def add(a, *args)
end
```


## 面向对象
```
arr=Array.new
p arr
p arr.class
arr = [1,2]
str = "hello world"
p arr.class
p str.class
p str.instance_of?(String)

# 实例变量@xx， 类变量@@yy所有实例共享
class HelloWorld
  @@count = 0
  def initialize(myname="Ruby")
    @name=myname
    @@count+=1
  end

  def hello
    puts "Hello #{@name}  / #{@@count}"
  end
end

hx = HelloWorld.new("Tomas")
hx2 = HelloWorld.new
hx.hello

# 类方法
# class HelloStatic
#   class << self
#     def hello(name)
#       puts "Hello static #{name}"
#     end
#   end
# end

# 类方法2, 类常量
class HelloStatic
  VERSION="v1.0"
end
def HelloStatic.hello(name)
  puts "Hello static #{name}"
end
HelloStatic.hello("Ruby")
puts HelloStatic::VERSION


# 访问级别 public(默认), private, protected
class AccTest
  def hello

  end
  public :hello

  def name

  end
  private :name
end
acc = AccTest.new
acc.hello


# 继承
class ArrayTest < Array
  def[](i)
    super(0)
  end
end
arr = ArrayTest.new([1,2,3])
puts arr[0]
puts arr[1]
puts arr[2]


# 模块， 命名空间
module Std
  STD_VERSION = "v17"  # 模块常量
  def hello

  end
  module_function :hello  # 模块方法
end
Std::hello
puts Std::STD_VERSION

include Std
puts STD_VERSION
```


## 异常

```
begin
  # File.open("aaa.txt")  # IOError
  # 抛出异常, RuntimeError
  raise
  raise("xyzwer")
rescue => ex
  # 错误处理, StandardError及其子类(RuntimeError)
  puts ex.message
ensure
  puts "finally" # 无论是否发生异常
end
```


## About Links

https://sinatra.ruby-lang.com.cn/intro.html

https://qiita.com/Alt70155/items/3965b4a9889698579df4