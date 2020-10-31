# My personal dotfiles

There are 3 types of environments dot files - local, server, wsl.

## Linux

### Basic usage

1. Clone:

    ```shell
    git clone https://github.com/gjirm/dotfiles.git ~/.dotfiles
    ```

2. Run ``./install.sh``

### Included scripts

* ``./install.sh`` - installs ``curl``, ``wget``, ``git``, ``zsh``, ``autojump`` ans ZSH plugins ``zsh-syntax-highlighting`` and ``zsh-autosuggestions`` and create dotfiles symlinks.

* ``./create-symlinks.sh`` - creates only dotfiles symlinks.

* ``./install-tools.sh`` - install some useful tools and languages like golang, step CLI, minio-client, webwormhole, age encryption etc..

## Windows

1. Open PowerShell as admin and install ``Chocolatey`` and ``git``

    ```powershell
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); choco install git -y
    ```

2. Open another PowerShell windows as admin and clone dotfiles repo

    ```powershell
    git clone https://github.com/gjirm/dotfiles.git ~/.dotfiles
    ```

3. Enter `.dotfiles` dir and run

    ```shell
    .\bootstrap.bat
    ```





```
```
```
```
```
```
