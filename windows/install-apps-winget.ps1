#Requires -RunAsAdministrator

function WingetInstall {
  winget install $args --accept-source-agreements --accept-package-agreements 
}

Write-Host "--> Installing Apps..." -ForegroundColor Green

# WingetInstall Google.Chrome
WingetInstall Mozilla.Firefox

#WingetInstall XPDP273C0XHQH2 # Adobe Acrobat Reader DC

WingetInstall 7zip.7zip

WingetInstall Iterate.Cyberduck
WingetInstall Iterate.MountainDuck 

WingetInstall sysinternals
WingetInstall VideoLAN.VLC
WingetInstall Oracle.JavaRuntimeEnvironment

WingetInstall 9NCBCSZSJRSB # spotify
WingetInstall Microsoft.VisualStudioCode
WingetInstall Git.Git

WingetInstall Microsoft.PowerShell
#WingetInstall Docker.DockerDesktop

# Make Dev Cert https://github.com/FiloSottile/mkcert
#WingetInstall FiloSottile.mkcert

#WingetInstall Microsoft.MouseWithoutBorders
#WingetInstall XP8K2L36VP0QMB # KeePassXC

# Cloud clients
#WingetInstall Microsoft.Azure.AZCopy.10
#WingetInstall Microsoft.Azure.StorageExplorer 
WingetInstall Amazon.AWSCLI
WingetInstall Microsoft.AzureCLI  
## choco install minio-client

# Other Tools 
#WingetInstall Microsoft.OpenSSH.Beta
#WingetInstall MarkText.MarkText
WingetInstall Obsidian.Obsidian

Write-Host "--> Done <--" -ForegroundColor Green
