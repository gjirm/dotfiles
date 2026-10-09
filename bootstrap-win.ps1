#Requires -RunAsAdministrator

# Imports
. ".\utils\functions.ps1"

Write-Host "--> Bootstraping Windows using winget <--" -ForegroundColor Green

Write-Host "--> Installing Powershell..." -ForegroundColor Green
WingetInstall Microsoft.PowerShell

Write-Host "--> Installing PowerShell modules ..." -ForegroundColor Green
#Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

$pwshExe = (Get-Childitem -Path "C:\Program Files\PowerShell\*\pwsh.exe" -Recurse).FullName

& "$pwshExe" -nologo -noprofile -command "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted"

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

if ( -not (Test-Path "${env:USERPROFILE}\Documents\PowerShell")) { 
  New-Item -Path "${env:USERPROFILE}\Documents\PowerShell" -ItemType Directory
}       

if ( -not (Test-Path "${env:USERPROFILE}\Documents\PowerShell\local_profile.ps1")) {
  New-Item -Path "${env:USERPROFILE}\Documents\PowerShell\local_profile.ps1" -ItemType "file" -Value ""
}

if ( -not (Test-Path "${env:USERPROFILE}\.config")) {
  New-Item -ItemType Directory -Force -Path "${env:USERPROFILE}\.config"
}    