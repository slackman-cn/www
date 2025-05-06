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

