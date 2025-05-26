---
title: JAVA Lib
since: 202503
---

## Library

https://mvn.coderead.cn/


[常用工具类] https://www.bilibili.com/video/BV1Lv411P7Ua/

[中间件] https://www.bilibili.com/video/BV1j64y187LK/

[面试题] https://www.bilibili.com/video/BV1Sg41157T5/


## IDE

```
cnki@192:~$ tail -n2 .bashrc 
export JAVA_HOME=/opt/jdk-17
export PATH=$JAVA_HOME/bin:$PATH

更新时间戳
cnki@192:~/Applications$ tar -xmf gigaideCE-242.21829.142.2.tar.gz
~/.config/GIGAIDE
~/.cache/GIGAIDE
~/.local/share/GIGAIDE

Create Desktop Entry
Appearance => Use Custom Font 
Editor => CodeStyle => Import Scheme (intellij-java-google-style.xml)
Plugin TestMe已安装，方法名context menu

JVM: kotlin, groovy souce build
CLI APP: shadowjar/piocli
GUI APP: swing/openJFX/swt
WEB APP:
```


## Maven Project

```
    <properties>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.test.skip>true</maven.test.skip>
    </properties>

    <dependencies>
        <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-classic</artifactId>
            <version>1.5.6</version>
        </dependency>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>5.10.2</version>
        </dependency>
    </dependencies>
```

Runnable Jar
```
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.8.1</version>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-jar-plugin</artifactId>
                <version>3.2.0</version>
                <configuration>
                    <finalName>getmac</finalName>
                    <archive>
                        <manifest>
                            <mainClass>com.example.App3</mainClass>
                        </manifest>
                    </archive>
                </configuration>
            </plugin>
        </plugins>
    </build>
```


## Maven Docker Build

https://github.com/kaiwinter/docker-java8-maven/blob/master/Dockerfile
```
docker volume create m2
docker inspect m2
sudo cp settings.xml  /var/lib/docker/volumes/m2/_data

docker run -it --rm -v m2:/root/.m2 -v "$PWD/target:/app/target" myapp bash
```

Dockerfile-ubuntu16
```
COPY sources.ubuntu16.list /etc/apt/sources.list
RUN apt-get update \
    && apt-get install -y binutils fakeroot \
    && apt-get clean

# install maven
ADD apache-maven-3.8.4-bin.tar.gz /opt
RUN ln -s /opt/apache-maven-3.8.4/bin/mvn /usr/local/bin

# install openjdk
ADD openjdk-11*_bin.tar.gz /usr/jvm
ENV JAVA_HOME /usr/jvm/jdk-11
ENV PATH $JAVA_HOME/bin:$PATH

CMD ["bash"]
```

Dockerfile-openjdk
```
FROM openjdk
MAINTAINER gg

# install maven
ADD doc/apache-maven-3.8.4-bin.tar.gz /opt
RUN ln -s /opt/apache-maven-3.8.4/bin/mvn /usr/local/bin

# Project
WORKDIR /app
COPY pom.xml .
COPY src ./src
#COPY file.ico .
#RUN mvn clean compile javafx:jlink jpackage:jpackage

CMD ["bash"]
```

Dockerfile-debian11
```
# COPY stretch-backports.list /etc/apt/sources.list.d/stretch-backports.list
RUN apt-get update \
    && apt-get install -y libavformat58 libgl1-mesa-dev \
    libx11-dev pkg-config x11proto-core-dev git \
    libgtk2.0-dev libgtk-3-dev \ 
    cmake bison flex gperf ruby \
    libxxf86vm-dev default-jdk \
    && apt-get clean

# Project
WORKDIR /opt
ADD jfx-jfx17.zip /opt

CMD ["bash"]
```

Dockerfile-debian9
```
#RUN apt-get update \
#    && apt-get install -y apt-transport-https ca-certificates


# change mirror
#COPY stretch-backports.list /etc/apt/sources.list.d/stretch-backports.list
COPY sources.list /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y cmake bison flex gperf ruby
RUN apt-get install -y libavformat57 libgl1-mesa-dev libx11-dev pkg-config x11proto-core-dev git libgtk2.0-dev libgtk-3-dev 
#RUN apt-get install -y build-essential
#RUN apt-get install -y cmake 
RUN apt-get install -y openjdk-11-jdk

# Project
WORKDIR /opt
ADD jfx-jfx17.zip /opt

CMD ["bash"]
```

## Gradle Project

https://services.gradle.org/

https://mirrors.huaweicloud.com/home
```
========== 镜像（全局）~/.gradle/init.gradle**
allprojects{
    repositories {
        maven {
            url 'https://repo.huaweicloud.com/repository/maven/'
        }
    }
    buildscript {
        repositories {
            maven {
                url 'https://repo.huaweicloud.com/repository/maven/'
            }
        }
    }
}

========== 镜像（项目）
repositories {
    maven("https://maven.aliyun.com/repository/public/")
    mavenCentral()
}

repositories {
    maven {
        allowInsecureProtocol true
        url "http://10.120.130.165:8081/repository/maven-public/"
    }
    mavenCentral()
}

--- kts
maven {
    isAllowInsecureProtocol = true
    url = uri("http://192.168.22.31:8081/repository/maven-public/")
}

========== IDEA中文乱码问题
Help -> Edit Custom VM Options…
输入 ：-Dfile.encoding=UTF-8

========== 依赖
本地 jar
implementation files("lib/webx-hfs-1.0.0.jar")

项目
implementation project(":hfs-lib")

排除依赖
implementation('net.cnki.webx:webx-hfs:1.1.0') {
    exclude group: "net.java.dev.jna"
}

========== 设置环境变量
tasks.test {
    useJUnitPlatform()
    systemProperty("jna.debug_load", "true")
    systemProperty("jna.library.path", "D:\\webx")
}

```

插件 java-library

https://discuss.gradle.org/t/when-should-we-use-java-plugin-and-when-java-library-plugin/25377

https://docs.gradle.org/current/userguide/java_library_plugin.html
```
plugins {
    id 'java-library'
}

compileJava {
    sourceCompatibility = '1.8'
    targetCompatibility = '1.8'
}

java {
    withSourceJar()
}

========== 打包 shadowjar
plugins {
    id 'java'
    id 'application'
    id 'com.github.johnrengelman.shadow' version "7.0.0"
}

mainClassName = 'example.App'
```

插件 cpp-library

```
org.gradle.nativeplatform.internal.DefaultTargetMachineFactory$TargetMachineImpl

在aarch64机器build失败，应该是只支持x86平台
Linux, Windows, MacOS

支持编译器ToolChain
visualCpp (Visual Studio)
gcc (GNU GCC)
clang (CLang)
```


## Console APP

```
--- 没有依赖
java -cp starter.jar example.App

--- 有依赖
java -cp "starter-1.0-SNAPSHOT.jar;C:\Users\gecha\.m2\repository\com\vdurmont\emoji-java\5.1.1\emoji-java-5.1.1.jar;C:\Users\gecha\.m2\repository\org\json\json\20170516\json-20170516.jar" example.App
```

https://picocli.info/
```
<dependency>
    <groupId>info.picocli</groupId>
    <artifactId>picocli</artifactId>
    <version>4.6.3</version>
</dependency>
```


## Desktop APP

Swing 框架
```
https://github.com/johnyNemo/swingMVP
https://github.com/mszalbach/SwingMVP

入门
https://www.javatpoint.com/java-swing
https://www.guru99.com/java-swing-gui.html

布局
https://www.miglayout.com
http://www.java2s.com/Code/Java/Swing-Components/BuildsthemainframeintheSimpleLooksDemo.htm
http://www.jgoodies.com/downloads/demos/
```

SWT 框架
```
package org.example;

import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;

public class Main {

    /**
     * Launch the application.
     * @param args
     */
    public static void main(String[] args) {
        Display display = Display.getDefault();
        Shell shell = new Shell();
        shell.setSize(450, 300);
        shell.setText("SWT Application");

        shell.open();
        shell.layout();
        while (!shell.isDisposed()) {
            if (!display.readAndDispatch()) {
                display.sleep();
            }
        }
    }

}
```

JFX 框架
```
https://github.com/databasefx/dbfx
https://github.com/imyeyu/better-fx

快速入门（只看布局和组件）
https://www.bilibili.com/video/BV1fW41167RP

完整教程（英文）
https://www.demo2s.com/java/javafx-printing.html
https://github.com/Pi4J/pi4j-template-javafx

组件
http://tutorials.jenkov.com/javafx/tableview.html
https://www.yiibai.com/javafx/javafx_textfield.html

图标
https://icons8.com/icons/set/file

异步任务
https://www.jianshu.com/p/97e02eccc87c
https://stackoverflow.com/questions/11703568/how-to-use-the-return-value-of-call-method-of-task-class-in-javafx
```