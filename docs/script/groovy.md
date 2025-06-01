---
title: Groovy Script
since: 202503
---

## apache-groovy-binary-3.0.22.zip

GROOVY_HOME, PATH
```
$> bin/groovy -version
Groovy Version: 3.0.22 JVM: 17.0.12 Vendor: Amazon.com Inc. OS: Linux


创建一个交互式 Groovy shell，您可以在其中键入 Groovy 语句
groovysh


运行 Swing 交互式控制台 (groovy-console-4.0.27.jar)
groovyConsole

. "$DIRNAME/startGroovy"
export JAVA_OPTS="-Dsun.awt.keepWorkingSetOnMinimize=true $JAVA_OPTS"
startGroovy groovy.console.ui.Console "$@"

运行特定的 Groovy 脚本
groovy SomeScript
groovyc MyClass.groovy  // MyClass.class
```


## apache-groovy-src-4.0.27.zip (Gradle 8.12)

https://github.com/apache/groovy

https://services.gradle.org/distributions/
```
JDK 16+

不是必要
gradle -p bootstrap
gradlew clean dist


gradle tasks
gradle build -x test  报错
gradle dist -x test   成功
```


## 新建 project (Gradle 8.12)

https://docs.gradle.org/current/samples/sample_building_groovy_applications.html

> gradle tasks
```
$> gradle init

Select type of build to generate:
  1: Application
  2: Library
  3: Gradle plugin
  4: Basic (build structure only)
Enter selection (default: Application) [1..4] 1

Select implementation language:
  1: Java
  2: Kotlin
  3: Groovy
  4: Scala
  5: C++
  6: Swift
Enter selection (default: Java) [1..6] 3

Enter target Java version (min: 7, default: 21):

Project name (default: demo):

Select application structure:
  1: Single application project
  2: Application and library project
Enter selection (default: Single application project) [1..2] 1

Select build script DSL:
  1: Kotlin
  2: Groovy
Enter selection (default: Kotlin) [1..2]
```

build.gradle
```
plugins {
    id 'groovy' 
    id 'application' 
}

repositories {
    mavenCentral() 
}

dependencies {
    implementation libs.groovy.all 

    implementation libs.guava 

    testImplementation libs.spock.core 
    testImplementation libs.junit

    testRuntimeOnly 'org.junit.platform:junit-platform-launcher'
}

application {
    mainClass = 'demo.App' 
}

tasks.named('test') {
    useJUnitPlatform() 
}
```