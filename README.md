# My personal dotfiles

There are 3 types of environments dot files - local, server, wsl.

## Basic usage

1. Clone:

    ```shell
    git clone https://github.com/gjirm/dotfiles.git ~/.dotfiles
    ```

2. Run ``./install.sh``

## Included scripts

* ``./install.sh`` - installs ``curl``, ``wget``, ``git``, ``zsh``, ``autojump`` ans ZSH plugins ``zsh-syntax-highlighting`` and ``zsh-autosuggestions`` and create dotfiles symlinks.

* ``./create-symlinks.sh`` - creates only dotfiles symlinks.

* ``./install-tools.sh`` - install some useful tools and languages like golang, step CLI, minio-client, webwormhole, age encryption etc..
