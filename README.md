# MkDocs

For full documentation visit [mkdocs.org](https://www.mkdocs.org).

## Commands

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs -h` - Print help message and exit.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.

## Install

```
sudo dnf install mkdocs
cp -a /usr/lib/python3.13/site-packages/mkdocs/themes/mkdocs .

# sudo apt install python3-venv python3-pip
# python3 -m venv vbuild && source bin/active
# pip install mkdocs
# pip install mkdocs-material
```