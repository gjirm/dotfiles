#Requires -RunAsAdministrator

# Imports
. ".\utils\functions.ps1"

function ChocoInstall {
  choco upgrade -y --not-broken --approved-only $args
}

Write-Host "--> Bootstraping Windows profile <--" -ForegroundColor Green

$systemProfile = Read-Host -Prompt "--> Enter the system profile type - personal"
$systemProfile = $systemProfile.ToLower()

switch ($systemProfile) {
    "personal" {
        $profilePath = "$PSScriptRoot\personal"
    }
    default {
        Write-Host "--! Profile not recognized! Exiting..." -ForegroundColor Yellow
        exit 1
    }
}

if( -not (test-path "C:\ProgramData\chocolatey\choco.exe") ) {
    Write-Host "--> Installing chocolatey..." -ForegroundColor Green
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

Write-Host "--> Installing apps..." -ForegroundColor Green
ChocoInstall git
ChocoInstall powershell-core
ChocoInstall microsoft-windows-terminal
ChocoInstall cascadiafonts
ChocoInstall fd
ChocoInstall fzf
ChocoInstall micro
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
scoop install starship

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# PowerShell Modules
# this will run under powershell 5
if (!(Get-Module posh-git)) {
  Write-Host "--> Installing posh-git in PowerShell 5 ..." -ForegroundColor Green
  Install-Module posh-git -Force
}

if (!(Get-Module oh-my-posh)) {
  Write-Host "--> Installing oh-my-posh in PowerShell 5 ..." -ForegroundColor Green
  Install-Module oh-my-posh -Force
}

if (!(Get-Module Get-ChildItemColor)) {
  Write-Host "--> Installing Get-ChildItemColor in PowerShell 5 ..." -ForegroundColor Green
  Install-Module -Name Get-ChildItemColor -Force -AllowClobber
}

$pwshExe = (Get-Childitem -Path "C:\Program Files\PowerShell\*\pwsh.exe" -Recurse).FullName

& "$pwshExe" -nologo -noprofile -command "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted"
#& "$pwshExe" -nologo -noprofile -command "Install-Module windows-screenfetch -Force"

Write-Host "--> Installing posh-git in PowerShell Core ..." -ForegroundColor Green
& "$pwshExe" -nologo -noprofile -command "Install-Module posh-git -Force"

Write-Host "--> Installing oh-my-posh in PowerShell Core ..." -ForegroundColor Green
& "$pwshExe" -nologo -noprofile -command "Install-Module oh-my-posh -Force"

Write-Host "--> Installing Get-ChildItemColor in PowerShell Core ..." -ForegroundColor Green
& "$pwshExe" -nologo -noprofile -command "Install-Module Get-ChildItemColor -Force -AllowClobber"

Write-Host "--> Installing PSReadLine in PowerShell Core ..." -ForegroundColor Green
& "$pwshExe" -nologo -noprofile -command "Install-Module -Name PSReadLine -AllowPrerelease -Force -SkipPublisherCheck"

Write-Host "--> Installing PSFzf in PowerShell Core ..." -ForegroundColor Green
& "$pwshExe" -nologo -noprofile -command "Install-Module -Name PSFzf -Force"

Write-Host "--> Installing WslInterop in PowerShell Core ..." -ForegroundColor Green
& "$pwshExe" -nologo -noprofile -command "Install-Module -Name WslInterop -Force"

# Delugia Nerd Font (Cascadia Code + Nerd Fonts)
# https://github.com/adam7/delugia-code
Write-Host "--> Delugia Nerd Font (Cascadia Code + Nerd Fonts) ..." -ForegroundColor Green
InstallFromGithub -repo "adam7/delugia-code" -filenamePattern "Delugia.Nerd.Font.Complete.ttf" -installPath "$PSScriptRoot"

.\Delugia.Nerd.Font.Complete.ttf

# Create my symlinks
. ".\create-symlinks.ps1"

# Setup my ENV variables
if ( $systemProfile -eq "personal") {
  . ".\create-my-user-env.ps1"
}
#. ".\install-apps.ps1"



