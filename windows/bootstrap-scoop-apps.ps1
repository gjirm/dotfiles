# Install cmd installer Scoop (https://scoop.sh/) includin my apps

Write-Host "--> Installing scoop..." -ForegroundColor Green
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
#Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
# or shorter
# iwr -useb get.scoop.sh | iex

Write-Host "--> Installing scoop package manager (https://scoop.sh)..." -ForegroundColor Green
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

#Write-Host "--> Installing starship shell-prompt (https://starship.rs)..." -ForegroundColor Green
#scoop install starship

Write-Host "--> Installing psutils (https://github.com/lukesampson/psutils)..." -ForegroundColor Green
scoop install psutils

# Delugia Nerd Font (Cascadia Code + Nerd Fonts)
# https://github.com/adam7/delugia-code
Write-Host "--> Delugia Nerd Font (Cascadia Code + Nerd Fonts - https://github.com/adam7/delugia-code) ..." -ForegroundColor Green
#scoop install git
scoop bucket add nerd-fonts
sudo scoop install Delugia-Nerd-Font-Complete
#scoop uninstall git

Write-Host "--> Adding scoop extras bucket..." -ForegroundColor Green
scoop bucket add extras

Write-Host "--> Installing apps..." -ForegroundColor Green

# https://www.voidtools.com/
#scoop install everything

# https://smallstep.com/cli/
# scoop bucket add smallstep https://github.com/smallstep/scoop-bucket.git
# scoop install smallstep/step

# https://github.com/FiloSottile/age
scoop install age

# https://cli.github.com/
scoop install gh

# https://github.com/junegunn/fzf
#scoop install fzf

# https://github.com/sharkdp/fd
#scoop install fd

# https://github.com/minio/mc
scoop install minio-client

# https://github.com/zyedidia/micro
#scoop install micro

# https://github.com/jedisct1/minisign
scoop install minisign

# https://github.com/stedolan/jq
scoop install jq

# https://github.com/microsoft/ethr
scoop install ethr

# https://github.com/ducaale/xh
scoop install xh

# https://github.com/sharkdp/bat
scoop install bat

# https://github.com/muesli/duf
scoop install duf

# https://github.com/dundee/gdu
scoop install gdu

# https://obsidian.md/
#scoop install obsidian

# https://diskanalyzer.com/
scoop install wiztree

# https://github.com/hashicorp/terraform
scoop install terraform

# https://keepassxc.org/
#scoop install keepassxc

# https://restic.net/
scoop install restic

# https://github.com/schollz/croc
scoop install croc

# https://slproweb.com/products/Win32OpenSSL.html
scoop install openssl

# https://github.com/goreleaser/goreleaser/
scoop bucket add goreleaser https://github.com/goreleaser/scoop-bucket.git
scoop install goreleaser

# https://github.com/taskctl/taskctl
# scoop bucket add taskctl https://github.com/taskctl/scoop-taskctl.git
# scoop install taskctl

# https://key.pub
# scoop bucket add keys.pub https://github.com/keys-pub/scoop-bucket
# scoop install libfido2
# scoop install keys

# https://github.com/hashicorp/vagrant
#scoop install vagrant

# https://eternallybored.org/misc/wget/
#scoop install wget

# https://github.com/facebook/zstd
#scoop install zstd

# https://github.com/gopasspw/gopass
#scoop install gopass

# https://github.com/ogham/dog
#scoop install dog

# https://github.com/OpenVPN/easy-rsa
#scoop install easyrsa


# https://github.com/gokcehan/lf
#scoop install lf

## Install Yazi ##
# https://github.com/sxyazi/yazi
scoop install yazi
# Install the optional dependencies (recommended):
scoop install unar jq poppler ripgrep zoxide imagemagick
[Environment]::SetEnvironmentVariable("YAZI_FILE_ONE ", "C:\Program Files\Git\usr\bin\file.exe","user")
Copy-Item -Path "$PSScriptRoot\personal\yazi\*" -Destination "${env:USERPROFILE}\AppData\Roaming\yazi" -Recurse
ya pack -a yazi-rs/plugins#full-border

Write-Host "--> Done <--" -ForegroundColor Green