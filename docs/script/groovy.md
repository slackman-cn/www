---
title: Groovy Script
since: 202503
---

## Install 

> apache-groovy-binary-3.0.22.zip

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


> apache-groovy-src-4.0.27.zip (Gradle 8.12)

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

## SwingBuilder

example1
```
import groovy.swing.SwingBuilder

import javax.swing.*
import javax.swing.JFrame
import javax.swing.WindowConstants
import java.awt.BorderLayout

static void main(String[] args) {
    def swing = new SwingBuilder()

    def buttonPanel = {
        swing.panel(constraints : BorderLayout.SOUTH) {

            button(text : 'Option A', actionPerformed : {
                println 'Option A chosen'
            })

            button(text : 'Option B', actionPerformed : {
                println 'Option B chosen'
            })
        }
    }

    def mainPanel = {
        swing.panel(layout : new BorderLayout()) {
            label(text : 'Which Option do you want',
                    horizontalAlignment : JLabel.CENTER,
                    constraints : BorderLayout.CENTER)
            buttonPanel()
        }
    }

    def myframe = swing.frame(
            title : 'Tutorials Point',
            location : [100, 100],
            size : [400, 300],
            defaultCloseOperation : WindowConstants.EXIT_ON_CLOSE){
        mainPanel()
    }

    myframe.setVisible(true)
}
```

example2
```
import groovy.swing.SwingBuilder

import javax.swing.WindowConstants
import java.awt.BorderLayout;

static void main(String[] args) {
    def swing = new SwingBuilder()

    swing.frame(title : 'Tutorials Point',
            location : [100, 100],
            size : [400, 300],
            layout: new BorderLayout(),
            show:true,
            defaultCloseOperation : WindowConstants.EXIT_ON_CLOSE,
    ){
        scrollPane(constraints: BorderLayout.CENTER) {
            textArea()
        }

        panel(constraints: BorderLayout.SOUTH) {
            button(text: 'Click', actionPerformed: {
                println 'hhhh'
            })
        }

    }
}
```




## SwingBuilder 链接

https://www.tutorialspoint.com/groovy/groovy_builders.htm

https://wizardforcel.gitbooks.io/ibm-j-pg/content/1.html

http://de.uwenku.com/question/p-yoayckhz-db.html

https://code.fandom.com/wiki/Groovy.swing.SwingBuilder

https://uberconf.com/blog/andres_almiray/2009/11/building_rich_swing_applications_with_groovy__part_i

https://freecontent.manning.com/wp-content/uploads/groovy-swingbuilder-and-threading.pdf

```
    def customMenuBar = {
        swing.menuBar{
            menu(text: "File", mnemonic: 'F') {
                menuItem(text: "Exit", mnemonic: 'X', actionPerformed: { dispose() })
            }
        }
    }

    def searchPanel = {
        swing.panel(constraints: BorderLayout.NORTH){
            searchField = textField(columns:15)
            button(text:"Search", actionPerformed:{ /* TODO */ } )
        }
    }
    
panel(id:'main') { 
    panel { 
     button(name:'x', action: action(name:'add', closure:{p.add(label('new')); p.revalidate()})) 
     button(action: action(name:'remove', closure:{p.removeAll();p.revalidate();scroll.repaint()})) 
    } 

    panel() { 
     scrollPane(id:'scroll',preferredSize: [200,200], constraints: context.CENTER) { 
       panel(id:'p') { 
        checkBoxList(listData: (1..20).collect([]){"Option $it"} as Object[]) 
       } 
     } 
   } 
} 
```

## Java Swing 绘制组件

https://zetcode.com/javaswing/painting/
```
import javax.swing.*;
import java.awt.*;

public class CustomPanel extends JPanel {
    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g); // Ensures the panel is rendered correctly
        g.setColor(Color.BLUE);
        g.fillRect(20, 20, 100, 100); // Custom drawing code
    }

    public static void main(String[] args) {
        JFrame frame = new JFrame();
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(300, 300);
        frame.add(new CustomPanel());
        frame.setVisible(true);
    }
}
```

## 算法4 类库

https://gitee.com/ZC_86/algorithms---4th-edition.git

直接复制 StdDraw.java 
```
int N = 100;
StdDraw.setXscale(0, N);
StdDraw.setYscale(0, N * N);
StdDraw.setPenRadius(.01);
for (int i=1; i<=N; i++) {
    StdDraw.point(i, i);
    StdDraw.point(i, i*i);
    StdDraw.point(i, i*Math.log(i));
}
```