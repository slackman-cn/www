---
title: Ruby Lib
since: 202503
---

## Install

https://www.ruby-lang.org/zh_cn/
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


## Install (Source)

https://docs.ruby-lang.org/en/master/contributing/building_ruby_md.html

```
======= 编译环境
sudo apt install autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
或者 sudo apt build-dep ruby

======= 源码
git clone https://github.com/ruby/ruby.git  -b v3_3_7
git clone http://192.168.22.239/github.com/ruby.git  -b v3_3_7 --depth=1

./autogen.sh
./configure --prefix=/opt/ruby-3   # 默认应该也是shared, 后面两个不确定
./configure --prefix=/opt/ruby-3 --enable-shared --with-ext=openssl,psych,+
make 
make install

root@ubuntu22:~/ruby# export PATH=/opt/ruby-3/bin:$PATH
root@ubuntu22:~/ruby# ruby --version
ruby 3.3.7 (2025-01-15 revision be31f993d7) [x86_64-linux]
root@ubuntu22:~/ruby# bundle --version
Bundler version 2.5.22
```


## 示例 SQLite

sudo apt install sqlite3
```
sqlite3 test.db  # 创建数据库
> .tables        # 所有表
> CREATE TABLE Testing(Id INTEGER);  
> .schema Testing   # 表定义
> .exit

SQL格式
CREATE TABLE [IF NOT EXISTS] [schema_name].table_name (
	column_1 data_type PRIMARY KEY,
   	column_2 data_type NOT NULL,
	column_3 data_type DEFAULT 0,
	table_constraints
) [WITHOUT ROWID];
```

gem install sqlite3
```
require 'sqlite3'

begin

    db = SQLite3::Database.open "test.db"
    db.execute "CREATE TABLE IF NOT EXISTS Cars(Id INTEGER PRIMARY KEY, 
        Name TEXT, Price INT)"
    db.execute "INSERT INTO Cars VALUES(1,'Audi',52642)"
    db.execute "INSERT INTO Cars VALUES(2,'Mercedes',57127)"
    db.execute "INSERT INTO Cars VALUES(3,'Skoda',9000)"

rescue SQLite3::Exception => e 

    puts "Exception occurred"
    puts e

ensure
    db.close if db
end
```

```
require 'sqlite3'

begin
    db = SQLite3::Database.open "test.db"

    stm = db.prepare "SELECT * FROM Cars LIMIT 5" 
    rs = stm.execute 

    rs.each do |row|
        puts row.join "\s"
    end

rescue SQLite3::Exception => e 
    puts "Exception occurred"
    puts e

ensure
    stm.close if stm
    db.close if db
end
```

## 示例 MySQL

gem install mysql2
```
需要安装系统库
sudo apt-get install libmysqlclient-dev

root@ubuntu22:~# gem install mysql2
Fetching mysql2-0.5.6.gem
Building native extensions. This could take a while...
Successfully installed mysql2-0.5.6

gem install mysql2 -v "0.5.3"
gem install mysql2 -v 0.5.6 -- --with-ldflags=-L$(brew --prefix zstd)/lib
```

查找数据
```
require 'mysql2'  
  
client = Mysql2::Client.new(  
  host: "localhost",  
  username: "your_username",  
  password: "your_password",  
  database: "your_database"  
)  
  
begin  
  # 执行数据库操作  
  results = client.query("SELECT * FROM your_table")  
  results.each do |row|  
    puts row.inspect  
  end  
rescue Mysql2::Error => e  
  puts e.message  
ensure  
  client.close if client  
end  
```

连接池
```
   pool = Mysql2::Client::ConnectionPool.new(size: 10)  
   pool.with do |client|  
     results = client.query("SELECT * FROM your_table")  
     # 处理结果  
   end  

防注入
client.query("SELECT * FROM your_table WHERE id = ?", [user_input])  
```