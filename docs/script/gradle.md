---
title: Gradle Script
since: 202506
---

## Gradle 脚本
https://docs.gradle.org.cn/current/userguide/logging.html

https://javaguide.cn/tools/gradle/gradle-core-concepts.html#gradle-%E4%BB%BB%E5%8A%A1

gradle -b logger.gradle <task>

```
task log() {
    doLast{    
        logger.quiet('quiet 重要消息')    
        logger.error('error 错误消息')    
        logger.lifecycle('lifecycler 进度消息')    
        logger.warn('warn 警告消息')    
        logger.info('info 消息 信息')    
        logger.debug('debug 调试信息')  
  }
}

gradle -b logger.gradle log

输出非常多DEBUG
gradle -b logger.gradle -d log

其他配置 -d 或 --debug； -i 或 --info
gradle run --info

gradle.properties 配置文件
org.gradle.logging.level=info
```

## Gradle Task & Plugin & Dependency

```
task hello {
     doLast {
       println "Hello"
     }
}

tasks.register("hello") {
    group = "task basic sample"
    description = "this is the first lovely task."
    doLast {
        println('Hello!')
    }
}

task clean(type: Delete) {
  delete rootProject.buildDir
}

tasks.register('removeInput', Delete) {
    delete 'inputs/3.txt'
}
```

脚本插件: 普通的脚本文件

二进制插件: 单独的插件模块，其他模块通过 Plugin ID 应用
```
apply from: rootProject.file('buildSrc/shared.gradle')

plugins {
    id 'java'
    id 'com.gradleup.shadow' version '8.3.4'
}

插件镜像地址 settings.gradle
pluginManagement {
    repositories {
        maven {
            url 'https://maven.aliyun.com/repository/gradle-plugin'
        }
        gradlePluginPortal()
        mavenCentral()
        jcenter()
    }
}
```

引入依赖
```
repositories {
	maven {
		url 'https://maven.aliyun.com/repository/public/'
	}
	maven {
		url 'https://maven.aliyun.com/repository/spring/'
	}
	mavenLocal()
	mavenCentral()
}

dependencies {
    testImplementation "junit:junit:4.13"
    
    implementation project(':shared')
    implementation project(':api')
    
    implementation files('libs/xxx.jar')
    implementation(fileTree("libs"));
}
```


## Gradle init {basic,application,library}

gradle-7.4-bin.zip

amazon-corretto-17-x64-linux-jdk.tar.gz
```
> mkdir myapp && cd
> gradle init
> gradle build

https://docs.gradle.org/current/samples/sample_building_java_applications.html

> gradle run
> gradle clean
> gradle test
> gradle javaToolchains

> gradle tasks
> gradle tasks --all
> gradle tasks --group=“build setup

plugins {
    id 'application' 
}

application {
    mainClass = 'demo.App' 
}

覆写一个任务
task copy(overwrite: true)
```


## Task 检查OS
https://stackoverflow.org.cn/questions/11235614

```
import org.gradle.internal.os.OperatingSystem;

task preCheck {
   description 'Run all conditional os tasks'
   doLast {
        println(OperatingSystem.current().isMacOsX())
        println(OperatingSystem.current().isLinux())
   }
}

task hello {
	doLast {
	    println 'hello onen'
	}
}

hello.onlyIf { !project.hasProperty('fensi') }
```

TinyLinux Distro
```
task build {
   description 'Make a tiny Linux from scratch on Linux'
   onlyIf { OperatingSystem.current().isLinux() }

   doFirst {
      println 'make toolchain; preCheck os host tools'
   }
   doLast {
      println 'make rootfs;  download file  wget source'
   }

}
```

## Task 依赖关系
https://docs.gradle.org/current/userguide/part2_gradle_tasks.html
https://bbs.huaweicloud.com/blogs/418868

```
task("H") {
  group("onenewcode") 
  description("this is the task H")
}

task welcome {
    group 'Sample category'
    description 'Tasks which shows a welcome message'
    doLast {
        println 'Welcome in the Baeldung!'
    }
}
```

依赖关系
```
tasks.register("hello") {
    doLast {
        println('Hello!')
    }
}

tasks.register("greet") {
    doLast {
        println('How are you?')
    }
    dependsOn("hello")
}

task A {
    println "配置阶段" 
    doFirst(){
        println "root taskA doFirst"
    }
    doLast(){
        println "root taskA doLast"
    }
}

//参数方式依赖: dependsOn后面用冒号
task 'C'(dependsOn: ['A', 'B']) {
    doLast {
        println "TaskC.."
    }
}

//参数方式依赖
task 'C' {
    //内部依赖：dependsOn后面用 = 号
    dependsOn= [A,B] 
    doLast {
        println "TaskC.."
    }
}

// 指定多个 task 依赖
task print(dependsOn :[second,first]) {
 doLast {
      logger.quiet "指定多个task依赖"
    }
}

// 指定一个 task 依赖
task third(dependsOn : print) {
 doLast {
      println '+++++third+++++'
    }
}
```

## Task 运行命令
https://docs.gradle.org/current/dsl/org.gradle.api.tasks.Exec.html
https://codippa.com/gradle-run-shell-script/

```
task build1(type: Exec) {
  workingDir "$projectDir/gradle"
   commandLine 'pwd'
}

task build2(type: Exec) {
   commandLine 'sh', '-c', 'date', '-R'
}

task execScripts {
    doLast {
        def script1 = "sh script1.sh".execute()
        script1.waitFor()

        def script2 = "sh script2.sh".execute()
        script2.waitFor()
    }
}
```

## Task 打包tar
https://dev59.com/7Z3ha4cB1Zd3GeqPS1Yw
https://docs.gradle.org.cn/current/dsl/org.gradle.api.tasks.bundling.Tar.html

```
task tgzTask(type: Tar) {
    into('app/') {
        from 'build/libs'
        include '*.jar'
    }
    into('app/') {
        from 'build/resources/main/banner.txt'
    }
    into('app/config') {
        from 'build/resources/main/config'
        from 'build/resources/main/banner.txt'
    }
    into('app/config/sql') {
        from 'build/resources/main/sql'
    }
    
    destinationDirectory = file('build/distributions')
    // 不写这两行就是tar
    extension 'tgz'
    compression = Compression.GZIP
}
```

## Task 下载文件， 拷贝文件
https://michelkraemer.com/gradle-download-task-download-files-with-progress/  
https://github.com/michel-kraemer/gradle-download-task  
https://plugins.gradle.org/plugin/de.undercouch.download

https://docs.gradle.org/current/userguide/working_with_files.html
```
最新版本 5.6.0
plugins {
    id "de.undercouch.download" version "5.0.0"
}

task downloadFile(type: Download) {
    src 'http://192.168.1.1/pub/gcc-7.3.0.tar.gz'
    dest buildDir
}
```