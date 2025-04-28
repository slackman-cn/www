---
title: 系统编译环境
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
https://www.jetbrains.com/lp/mono/
sudo unzip JetBrainsMono-2.304.zip -d /usr/local/share/fonts/JetBrains-Mono
'Jetbrains Mono', 'Droid Sans Mono', 'monospace', monospace
```


