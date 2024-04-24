#Requires -RunAsAdministrator

# Imports
. ".\utils\functions.ps1"

Write-Host "--> Installing Apps..." -ForegroundColor Green

# WingetInstall Google.Chrome
WingetInstall Mozilla.Firefox

WingetInstall XPDP273C0XHQH2 # Adobe Acrobat Reader DC

WingetInstall 7zip.7zip

WingetInstall Iterate.Cyberduck
WingetInstall Iterate.MountainDuck 

WingetInstall alexx2000.DoubleCommander

WingetInstall voidtools.Everything

WingetInstall sysinternals
WingetInstall VideoLAN.VLC
WingetInstall Oracle.JavaRuntimeEnvironment

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
## choco install minio-client

# Other Tools 
WingetInstall ProtonTechnologies.ProtonVPN
#WingetInstall Microsoft.OpenSSH.Beta
#WingetInstall MarkText.MarkText
WingetInstall Obsidian.Obsidian
WingetInstall Smallstep.step

Write-Host "--> Done <--" -ForegroundColor Green
