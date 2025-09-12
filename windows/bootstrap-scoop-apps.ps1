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

# https://github.com/jdx/mise
scoop install mise

# https://github.com/FiloSottile/age
scoop install age

# https://github.com/microsoft/ethr
scoop install ethr

## Install Yazi dependencies ##
# https://github.com/sxyazi/yazi
#scoop install yazi
# Install the optional dependencies (recommended):
scoop install poppler
#scoop install ffmpeg 7zip jq poppler fd ripgrep fzf zoxide imagemagick

Write-Host "--> Done <--" -ForegroundColor Green