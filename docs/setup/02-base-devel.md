---
title: 系统开发环境
since: 202503
---

## Development

```
sudo apt install build-essential cmake meson
sudo apt install crossbuild-essential-arm64

eclipse-cpp.tar.gz
sudo apt install qtcreator qtbase5-dev
sudo apt install libwxgtk3.2-dev codelbocks

>> user-wide
sudo apt install python3-venv
python3 -m venv myenv
source myenv/bin/activate
```


## Editor & Fonts

sudo apt install mousepad vim
```
>> vi .vimrc
if has('mouse')
  set mouse-=a
endif

>> fc-list | grep JetBrains
>> fc-cache -v

https://www.jetbrains.com/lp/mono/
sudo unzip JetBrainsMono-2.304.zip -d /usr/local/share/fonts/JetBrains-Mono
'Jetbrains Mono', 'Droid Sans Mono', 'monospace', monospace

# jetbrains nerd font. Necessary for waybar
https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd
tar -xJkf JetBrainsMono.tar.xz -C ~/.local/share/fonts/JetBrainsMonoNerd

# Fantasque Mono Nerd Font
https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FantasqueSansMono.zip
https://rubjo.github.io/victor-mono/VictorMonoAll.zip
$HOME/.local/share/fonts/FantasqueSansMono
$HOME/.local/share/fonts/VictorMono
```


## EditorConfig  

VSCode 需要插件，IDEA不需要

https://editorconfig.org/
```
cat << EOF > .editorconfig
root = true
[*]
indent_style = space
indent_size = 4
EOF
```

## Java IDE

https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml
```
cnki@192:~$ tail -n2 .bashrc 
export JAVA_HOME=/opt/jdk-17
export PATH=$JAVA_HOME/bin:$PATH

// 更新时间戳
cnki@192:~/Applications$ tar -xmf gigaideCE-242.21829.142.2.tar.gz
~/.config/GIGAIDE
~/.cache/GIGAIDE
~/.local/share/GIGAIDE

Create Desktop Entry
Appearance => Use Custom Font 
Editor => CodeStyle => Import Scheme (intellij-java-google-style.xml)
Plugin TestMe已安装，方法名context menu
```

https://mvn.coderead.cn/
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