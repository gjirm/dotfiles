#Requires -RunAsAdministrator

# Imports
. ".\utils\functions.ps1"

Write-Host "--> Bootstraping Windows using winget <--" -ForegroundColor Green

Write-Host "--> Installing apps..." -ForegroundColor Green
winget install Git.Git
winget install Microsoft.PowerShell
winget install sharkdp.fd
winget install junegunn.fzf
winget install zyedidia.micro

Write-Host "--> Installing PowerShell modules ..." -ForegroundColor Green
#Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

$pwshExe = (Get-Childitem -Path "C:\Program Files\PowerShell\*\pwsh.exe" -Recurse).FullName

& "$pwshExe" -nologo -noprofile -command "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted"
#& "$pwshExe" -nologo -noprofile -command "Install-Module windows-screenfetch -Force"

# Write-Host "--> Installing Get-ChildItemColor in PowerShell Core ..." -ForegroundColor Green
# & "$pwshExe" -nologo -noprofile -command "Install-Module Get-ChildItemColor -Force -AllowClobber"

Write-Host "--> Installing Terminal-Icons in PowerShell Core ..." -ForegroundColor Green
& "$pwshExe" -nologo -noprofile -command "Install-Module -Name Terminal-Icons"

Write-Host "--> Installing PSReadLine in PowerShell Core ..." -ForegroundColor Green
& "$pwshExe" -nologo -noprofile -command "Install-Module -Name PSReadLine -AllowPrerelease -Force -SkipPublisherCheck"

Write-Host "--> Installing PSFzf in PowerShell Core ..." -ForegroundColor Green
& "$pwshExe" -nologo -noprofile -command "Install-Module -Name PSFzf -Force"

Write-Host "--> Installing PSEverything in PowerShell Core ..." -ForegroundColor Green
& "$pwshExe" -nologo -noprofile -command "Install-Module -Name PSEverything -Force"

Write-Host "--> Installing WslInterop in PowerShell Core ..." -ForegroundColor Green
& "$pwshExe" -nologo -noprofile -command "Install-Module -Name WslInterop -Force"

Write-Host "--> Install manually Windows Terminal if not installed: https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701" -ForegroundColor Yellow
Write-Host "--> To finish bootstrap run .\bootstrap-scoop-apps.ps1 as non-admin user." -ForegroundColor Yellow

# Create my symlinks
. ".\create-symlinks.ps1"


#. ".\install-apps.ps1"
