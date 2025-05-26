---
title: JAVA
since: 202503
---

## Install

https://injdk.cn/    

https://jdk.java.net/archive/

https://hollischuang.github.io/toBeTopJavaer/

```
JDK8  (2014)
 - Lambda 表达式
 - 方法引用
 - 默认方法
 - Stream API
 - Data Time API
 - Optional类

System.setProperty("jna.debug_load", "true");
System.out.println("JNA Loaded: " + System.getProperty("jna.loaded"));
System.out.println("当前日期: " + LocalDateTime.now());
System.out.println("操作系统: " + System.getProperty("os.name"));
System.out.println("系统版本: " + System.getProperty("os.version"));
System.out.println("系统架构: " + System.getProperty("os.arch"));
System.out.println("tmpdir java: " + System.getProperty("java.io.tmpdir"));
System.out.println("tmpdir jna : " + System.getProperty("jna.tmpdir"));
...
System.out.println("JNA Loaded: " + System.getProperty("jna.loaded"));
```

## 模块化

https://zhuanlan.zhihu.com/p/142697835

class是jvm最小可执行文件，jar文件是管理class文件的容器

javac Hello.java  &&  java Hello

```
java -jar hello.jar
java --module-path hello.jar --module first


class: 属性、方法集合
package: class集合
module: package集合

基础模块 java.base
java --list-modules
java --describe-module java.base

========= module-info.class（放在 java 目录）
module example.first {
    requires java.base; // 可不写，任何模块都会自动引入java.base
    requires java.xml;
}
```

模块优点

```
解决依赖关系，module-info.class
JVM标准库rt.jar 已经拆分为几十个模块，位置${JAVA_HOME}/jmods/*.jmod
java.base根模块，可不写

class封装为jar只需要打包
class封装为jmod不但要打包，还要写入依赖关系，可以包含二进制代码 

// 编译src所有java文件，存放在bin目录
javac -d build src/module-info.java src/com/*.java

// package jar
jar --create --file hello.jar --main-class com.Hello -C build .

// package jmod
jmod create --class-path hello.jar hello.jmod

========== java9之前
Java程序生成自己的jar文件
第三方jar包
Java标准库 rt.jar

// jvm标准库不需要写到classpath
java -cp myapp.jar:a.jar:b.jar com.example.App

// 缺点
少个某个jar抛异常ClassNotFoundException，原因是jar只是存放class的容器，不关心依赖
```


## jlink  &  jpackage

https://www.baeldung.com/jlink

https://dev.java/learn/creating-runtime-and-application-images-with-jlink/

https://www.devdungeon.com/content/how-create-java-runtime-images-jlink

```
jlink --module-path hello.jmod --add-modules java.base,first --output jre/

打包jre (精简)
jlink --launcher myapp=first/com.Hello \
 --strip-debug --compress 2 --no-header-files --no-man-pages \
 --module-path hello.jmod --add-modules java.base,first --output jre2/

jlink 减小体积
--strip-debug
--compress 2
--no-header-files
--no-man-pages

========= 运行
jre/bin/java --module first
jre/bin/java -m first
jre2/bin/myapp
```

打包 jpackage

Linux: rpmutil, dpkg, fakeroot

Windows: WixToolset

macOS：XCode command line tools

```
jpackage --runtime-image customjre --module first/com.company.Main

jpackage --runtime-image jre2 --type app-image --name JFX  --module first/com.Hello
--moudle 模块的名字,相当于以前的Main函数的格式,这里换成了模块 '包名'/Main函数名

实际命令
Command line was: /bin/sh -c /usr/jvm/jdk-17.0.1/bin/jpackage --name TreeFX \
 --dest /app/target/dist \
 --type app-image \
 --app-version 1.0.0 \
 --runtime-image /app/target/treefx \
 --vendor org.acme \
 --module treefx/com.acme.treefx.TreeFX \
 --icon /app/duke.png \
 --java-options -Dfile.encoding=UTF-8 \
 --linux-package-name treefx \
 --linux-menu-group Utilities \
 --linux-app-category Utilities \
 --linux-shortcut
```

## 多线程

• 通过实现 Runnable 接口  
• 通过继承  Thread 类本身  
• 通过 Callable 和 Future 创建线程。  

```
new MyThread().start();
new Thread(new MyRunnable()).start();
重写 public void run();

=====
FutureTask<String> task = new FutureTask<>(new Callable<String>() {
    @Override
    public String call() throws Exception {
        return "hello";
    }
});

// 使用Future获得异步执行结果时，要么调用阻塞方法get()，要么轮询看isDone()是否为true
// 主线程也会被迫等待
new Thread(task).start();
try {
    String res = task.get();
    System.out.println(res);
} catch (InterruptedException | ExecutionException e) {
    throw new RuntimeException(e);
}
```

CompletableFuture  (JDK8)  回调方法
```
// 创建异步任务
CompletableFuture<Double> cf = CompletableFuture.supplyAsync(() -> {
    try {
        Thread.sleep(100);
    } catch (InterruptedException e) {}
    if (Math.random() < 0.3) {
        throw new RuntimeException("fetch price failed!");
    }
    return 5 + Math.random() * 20;
});
// 执行成功
cf.thenAccept((result) -> {
    System.out.println("price: " + result);
});
// 执行异常
cf.exceptionally((e) -> {
    e.printStackTrace();
    return null;
});
// 主线程不要立刻结束，否则CompletableFuture默认使用的线程池会立刻关闭:
Thread.sleep(200);
```

Thread Pool
```
ExecutorService es = Executors.newFixedThreadPool(10);

//执行线程操作
// es.execute(...); 适合Runnable
// es.submit(...);  适合Callable

//关闭线程池
es.shutdown();

============ SYNC
LongAdder adder = new LongAdder();
es.execute(() -> {
    adder.increment();
    log.info("sub job {}", adder.intValue());
});

============= Share
ThreadLocal<User> threadLocalUser = new ThreadLocal<>();
threadLocalUser.set(user);
User u = threadLocalUser.get();
threadLocalUser.remove();
```

Virtual Thread  (JDK 19/21)

https://liaoxuefeng.com/books/java/threading/virtual-thread/index.html 

```
ExecutorService es = Executors.newVirtualThreadPerTaskExecutor();
es.submit(...);

// 传入Runnable并立刻运行:
Thread vt = Thread.startVirtualThread(() -> {
    System.out.println("Start virtual thread...");
    Thread.sleep(10);
    System.out.println("End virtual thread.");
});
```


## 单元测试 

Junit4
```
<!-- https://mvnrepository.com/artifact/junit/junit -->
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.13</version>
    <scope>test</scope>
</dependency>

Junit4中的@Test是import org.junit.Test;
@BeforeAll, @BeforeEach, @AfterAll, @AfterEach, @Disabled
```

Junit5
```
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter</artifactId>
    <version>5.10.2</version>
</dependency>

<!-- https://mvnrepository.com/artifact/org.junit.jupiter/junit-jupiter-api -->
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-api</artifactId>
    <version>5.7.2</version>
    <scope>test</scope>
</dependency>

Jupiter中的@Test是import org.junit.jupiter.api.Test;
@BeforeClass, @Before, @AfterClass, @After, @Ignore
```

env
```
========== 断言
assertEquals(expected, actual)
assertTrue(booleanExpression)
assertFalse(booleanExpression)
assertNull(actual)
assertNotNull(actual)

=========== 其他注解
@DisplayName("It tests the length of student name should less than 10 chars")

BusinessException businessException = Assertions.
   assertThrows(BusinessException.class, this::buildStudentDescription);

=========== 设置环境变量
https://junit-pioneer.org/docs/system-properties/
<!-- https://mvnrepository.com/artifact/org.junit-pioneer/junit-pioneer -->
<dependency>
    <groupId>org.junit-pioneer</groupId>
    <artifactId>junit-pioneer</artifactId>
    <version>1.4.2</version>
    <scope>test</scope>
</dependency>

@SetSystemProperty(key = "jna.debug_load", value = "true")
@SetSystemProperty(key = "jna.library.path", value = "C:\\jna")
```


## 日志 logging 内置模块

```
System.setProperty("java.util.logging.SimpleFormatter.format",
    "[%1$tF %1$tT] [%4$-2s] %5$s %n");

Logger log = Logger.getGlobal();
FileHandler fileHandler = new FileHandler("app.log");
fileHandler.setFormatter(new SimpleFormatter());  
log.addHandler(fileHandler);

log.info("hello");
log.info("hello2");
```

参考
```
https://www.logicbig.com/tutorials/core-java-tutorial/logging/customizing-default-format.html
https://geekdaxue.co/read/xinblog@javalog/itkt7t
https://zhuanlan.zhihu.com/p/505339189

System.setProperty("java.util.logging.SimpleFormatter.format",
    "[%1$tT %1$tL] %5$s %n");
```


## 日志 logback (Spring默认)

```
private static final Logger log = LoggerFactory.getLogger(App1.class);
log.info("hello {}", 123);

<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-classic</artifactId>
    <version>1.5.6</version>
</dependency>
```

logback.xml
```
<configuration>
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>
    <appender name="FILE" class="ch.qos.logback.core.FileAppender">
        <file>tests.log</file>
        <append>true</append>
        <encoder>
            <pattern>%-4relative [%thread] %-5level %logger{35} - %msg%n</pattern>
        </encoder>
    </appender>

    <root level="debug">
        <appender-ref ref="STDOUT" />
        <appender-ref ref="FILE" />
    </root>
</configuration>
```


## About 

logback.xml
```
<?xml version="1.0" encoding="UTF-8"?>
<configuration>

    <property name="LOGS" value="./logs" />

    <appender name="Console"
              class="ch.qos.logback.core.ConsoleAppender">
        <layout class="ch.qos.logback.classic.PatternLayout">
            <Pattern>
                %black(%d{ISO8601}) %highlight(%-5level) [%blue(%t)] %yellow(%C{1.}): %msg%n%throwable
            </Pattern>
        </layout>
    </appender>

    <appender name="RollingFile"
              class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOGS}/spring-boot-logger.log</file>
        <encoder
                class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <Pattern>%d %p %C{1.} [%t] %m%n</Pattern>
        </encoder>

        <rollingPolicy
                class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- rollover daily and when the file reaches 10 MegaBytes -->
            <fileNamePattern>${LOGS}/archived/spring-boot-logger-%d{yyyy-MM-dd}.%i.log
            </fileNamePattern>
            <timeBasedFileNamingAndTriggeringPolicy
                    class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>10MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
        </rollingPolicy>
    </appender>

    <!-- LOG everything at INFO level -->
    <root level="info">
        <appender-ref ref="RollingFile" />
        <appender-ref ref="Console" />
    </root>

    <!-- LOG "com.baeldung*" at TRACE level -->
    <logger name="com.baeldung" level="trace" additivity="false">
        <appender-ref ref="RollingFile" />
        <appender-ref ref="Console" />
    </logger>

</configuration>
```

DemoApplication.java
```
package com.example.demo;

import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.system.ApplicationHome;
import org.springframework.core.convert.Property;
import org.springframework.core.io.ClassPathResource;
import org.springframework.util.ResourceUtils;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URL;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.Collections;
import java.util.Properties;

@SpringBootApplication
@Slf4j
public class DemoApplication {

	public static void main(String[] args) {
//		ApplicationHome home = new ApplicationHome(DemoApplication.class);
//		if (home.getSource().getAbsolutePath().endsWith("jar")) {
//			String[] newArgs = new String[args.length + 1];
//			System.arraycopy(args, 0, newArgs, 0, args.length);
//			newArgs[args.length] = "-Dlogging.file.path=" + home.getSource().getParent();
//			args = newArgs;
//			String logPath = System.getProperty("-Dlogging.file.path");
//			System.out.println(logPath);
//			System.setProperty("-Dlogging.file.path", home.getSource().getParent());
//		}

//		try {
//			Properties prop = new Properties();
//			prop.load(DemoApplication.class.getClassLoader().getResourceAsStream("application.properties"));
//			System.out.println(prop);
//		} catch (IOException e) {
//
//		}

//		ClassPathResource r = new ClassPathResource("application.properties");
//
//		String logPath = System.getProperty("-Dlogging.file.path");
//		System.out.println(logPath);
		ApplicationHome home = new ApplicationHome(DemoApplication.class);
		SpringApplication app = new SpringApplication(DemoApplication.class);
		app.setDefaultProperties(Collections.singletonMap("logging.file.path", home.getSource().getParent()));
		app.run(args);

//		SpringApplication.run(DemoApplication.class, args);
	}

	Logger LOG = LoggerFactory.getLogger(DemoApplication.class);

//	@Value("${user.dir}")
//	private Object dir;
//
	@Value("${logging.file.path}")
	private String path;

//	@Value("${server.port}")
//	private String port;

	@PostConstruct
	public void init() {
//		URL url = ResourceUtils.getURL("");
//		System.out.println(url);

//		File file = ResourceUtils.getFile("classpath:application.properties");
//		System.out.println(file.toURI());

//		ClassPathResource r = new ClassPathResource("application.properties");
//		System.out.println(r.getURL());
//		System.out.println(r.getURI());
//		Path path = Path.of(r.getURI());
//		System.out.println(path);

//		File file = new File(".");
//		System.out.println(file.isDirectory());
//		System.out.println(file.getAbsolutePath());

		System.out.println("---------get log path----------");
		System.out.println(path);
//		ApplicationHome home = new ApplicationHome(this.getClass());
//		System.out.println(home.getSource().getAbsolutePath());
//		System.out.println(home.getSource().getParent());
//		System.out.println(home.getSource().getPath());
//		LOG.info(home.getSource().getParent());
//		System.out.println(dir);
	}
}

```