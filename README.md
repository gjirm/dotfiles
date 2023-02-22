# My personal dotfiles

There are 3 types of environments dot files - local, server, wsl.

## Rspberry Pi >= 10 (buster)

### Basic usage on RPi

1. Clone:

    ```shell
    git clone https://github.com/gjirm/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles/linux
    chmod +x ./bootstrap.sh
    ```

2. Run ``./bootstrap.sh``

## Linux Ubuntu >= 16.04

### Basic usage

1. Clone:

    ```shell
    git clone https://github.com/gjirm/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles/linux
    chmod +x ./bootstrap.sh
    ```

2. Run ``./bootstrap.sh``

### Included scripts

* ``./create-my-env-vars.sh`` - creates environment variables for my default paths: SSH, WORK, GIT...

* ``./create-symlinks.sh`` - creates only dotfiles symlinks.

* ``./install-apps.sh`` - install some useful tools and languages like golang, step CLI, minio-client, webwormhole, age encryption etc..

## Windows

1. Open PowerShell as admin and install ``Chocolatey`` and ``git``

    ```powershell
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); choco install git -y
    ```

2. Open another PowerShell windows as admin and clone dotfiles repo

    ```powershell
    git clone https://github.com/gjirm/dotfiles.git $env:userprofile\.dotfiles
    ```

3. Enter `~\.dotfiles\windows` dir and run

    ```shell
    .\bootstrap.bat
    ```
