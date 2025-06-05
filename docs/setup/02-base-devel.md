---
title: 系统开发环境
since: 202503
---

## Development

https://ftp.mozilla.org/pub/firefox/releases/137.0.2/linux-x86_64/en-GB/firefox-137.0.2.tar.xz

https://cdn1.waterfox.net/waterfox/releases/6.5.7/Linux_x86_64/waterfox-6.5.7.tar.bz2
```
sudo apt install language-pack-en  
sudo apt install language-pack-zh-hans
>> locale -a
>> cat /etc/default/locale


sudo apt install build-essential cmake ninja-build
sudo apt install crossbuild-essential-arm64

eclipse-cpp.tar.gz
sudo apt install qtbase5-dev
sudo apt install libwxgtk3.2-dev codelbocks
sudo apt install --no-install-recommends qtcreator

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

## 在线 IDE

MIT协议
https://github.com/gitpod-io/openvscode-server
```
容器有问题，挂载的目录都是root权限，容器内是普通用户
podman run  -d  --name code --init -p 3001:3000 \
   -v "$(pwd):/home/workspace:cached" gitpod/openvscode-server

直接启动可以，工作目录是 $home
openvscode-server-v1.96.0-linux-x64.tar.gz
./bin/openvscode-server --port 3001
./bin/openvscode-server --host 192.168.1.210
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