#Requires -RunAsAdministrator

function ChocoInstall {
  choco upgrade -y --not-broken --approved-only $args
}

Write-Host "--> Bootstraping Windows profile <--" -ForegroundColor Green

$systemProfile = Read-Host -Prompt "--> Enter the system profile type - personal"

switch ($systemProfile) {
    "personal" {
        $profilePath = (Get-Item ".").FullName + "\personal"
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

ChocoInstall git
ChocoInstall powershell-core
ChocoInstall microsoft-windows-terminal
ChocoInstall cascadiafonts

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# PowerShell Modules
# this will run under powershell 5
if (!(Get-Module posh-git)) {
  Install-Module posh-git -Force
}

if (!(Get-Module oh-my-posh)) {
  Install-Module oh-my-posh -Force
}

if (!(Get-Module Get-ChildItemColor)) {
  Install-Module -Name Get-ChildItemColor -Force -AllowClobber
}

$pwshExe = (Get-Childitem -Path "C:\Program Files\PowerShell\*\pwsh.exe" -Recurse).FullName
& "$pwshExe" -nologo -noprofile -command "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted"
#& "$pwshExe" -nologo -noprofile -command "Install-Module windows-screenfetch -Force"
& "$pwshExe" -nologo -noprofile -command "Install-Module posh-git -Force"
& "$pwshExe" -nologo -noprofile -command "Install-Module oh-my-posh -Force"
& "$pwshExe" -nologo -noprofile -command "Install-Module Get-ChildItemColor -Force -AllowClobber"
& "$pwshExe" -nologo -noprofile -command "Install-Module -Name PSReadLine -AllowPrerelease -Force -SkipPublisherCheck"

# this will be installed under pwsh core
# start-process "$pwshExe" -argument '-nologo -noprofile -command Set-PSRepository -Name PSGallery -InstallationPolicy Trusted'
# start-process "$pwshExe" -argument '-nologo -noprofile -command Install-Module windows-screenfetch -Force'
# start-process "$pwshExe" -argument '-nologo -noprofile -command Install-Module posh-git -Force'
# start-process "$pwshExe" -argument '-nologo -noprofile -command Install-Module oh-my-posh -Force'
# start-process "$pwshExe" -argument '-nologo -noprofile -command Install-Module Get-ChildItemColor -Force -AllowClobber'
# start-process "$pwshExe" -argument '-nologo -noprofile -command Install-Module -Name PSReadLine -AllowPrerelease -Force -SkipPublisherCheck'

. ".\create-symlinks.ps1"
#. ".\install-apps.ps1"


