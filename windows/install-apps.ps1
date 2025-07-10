#Requires -RunAsAdministrator

# Imports
. ".\utils\functions.ps1"

Write-Host "--> Installing Apps..." -ForegroundColor Green

# WingetInstall Google.Chrome
WingetInstall Mozilla.Firefox

#WingetInstall XPDP273C0XHQH2 # Adobe Acrobat Reader DC

WingetInstall 7zip.7zip

WingetInstall Iterate.Cyberduck
WingetInstall Iterate.MountainDuck 

WingetInstall alexx2000.DoubleCommander

WingetInstall voidtools.Everything

WingetInstall sysinternals
WingetInstall VideoLAN.VLC
#ingetInstall Oracle.JavaRuntimeEnvironment

WingetInstall tailscale.tailscale
WingetInstall WireGuard.WireGuard

WingetInstall 9NCBCSZSJRSB # spotify
WingetInstall Microsoft.VisualStudioCode

WingetInstall Docker.DockerDesktop

# Make Dev Cert https://github.com/FiloSottile/mkcert
#WingetInstall FiloSottile.mkcert

WingetInstall Microsoft.MouseWithoutBorders
WingetInstall XP8K2L36VP0QMB # KeePassXC
WingetInstall XP89DCGQ3K6VLD # PowerToys
WingetInstall Greenshot.Greenshot
WingetInstall NickeManarin.ScreenToGif

# Cloud clients
#WingetInstall Microsoft.Azure.AZCopy.10
#WingetInstall Microsoft.Azure.StorageExplorer 
WingetInstall Amazon.AWSCLI
WingetInstall Microsoft.AzureCLI
WingetInstall Hashicorp.Terraform
#WingetInstall MinIO.Client

# Other Tools 
WingetInstall ProtonTechnologies.ProtonVPN
WingetInstall Microsoft.OpenSSH.Beta
#WingetInstall MarkText.MarkText
WingetInstall Obsidian.Obsidian
WingetInstall Smallstep.step
WingetInstall vcsjones.AzureSignTool
WingetInstall jedisct1.minisign

# https://diskanalyzer.com/
WingetInstall AntibodySoftware.WizTree

# https://github.com/mr-karan/doggo
WingetInstall MrKaran.Doggo

# https://github.com/goreleaser/goreleaser/
WingetInstall goreleaser.goreleaser  

# https://restic.net/
WingetInstall restic.restic

# https://github.com/schollz/croc
WingetInstall schollz.croc

# https://slproweb.com/products/Win32OpenSSL.html
WingetInstall ShiningLight.OpenSSL.Light 

# https://github.com/sharkdp/bat
WingetInstall sharkdp.bat

# https://github.com/rclone/rclone
WingetInstall Rclone.Rclone

# cppcryptfs
WingetInstall BaileyBrown.cppcryptfs
WingetInstall dokan-dev.Dokany

# Yazi
WingetInstall sxyazi.yazi
WingetInstall Gyan.FFmpeg
WingetInstall jqlang.jq
WingetInstall ImageMagick.ImageMagick
WingetInstall BurntSushi.ripgrep.MSVC
[Environment]::SetEnvironmentVariable("YAZI_FILE_ONE ", "C:\Program Files\Git\usr\bin\file.exe","user")
ya pkg -a yazi-rs/plugins:full-border

Write-Host "--> Done <--" -ForegroundColor Green
