
function ChocoInstall {
  choco upgrade -y --not-broken --approved-only $args
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

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

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
# this will be installed under pwsh core
start-process "$pwshExe" -argument '-nologo -noprofile -command Set-PSRepository -Name PSGallery -InstallationPolicy Trusted'
start-process "$pwshExe" -argument '-nologo -noprofile -command Install-Module windows-screenfetch -Force'
start-process "$pwshExe" -argument '-nologo -noprofile -command Install-Module posh-git -Force'
start-process "$pwshExe" -argument '-nologo -noprofile -command Install-Module oh-my-posh -Force'
start-process "$pwshExe" -argument '-nologo -noprofile -command Install-Module Get-ChildItemColor -Force -AllowClobber'
start-process "$pwshExe" -argument '-nologo -noprofile -command Install-Module -Name PSReadLine -AllowPrerelease -Force -SkipPublisherCheck'

. ".\create-symlinks.ps1"
