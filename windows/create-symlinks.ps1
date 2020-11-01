#Requires -RunAsAdministrator

$timeStamp = Get-Date -Format "yyyy-MM-dd_HHmmss"

Write-Host "--> Creating profile symlinks <--" -ForegroundColor Green

if ( -not $systemProfile) {
  $systemProfile = Read-Host -Prompt "--> Enter the system profile type - personal"
}

switch ($systemProfile) {
    "personal" {
        $profilePath = "$PSScriptRoot\personal"
    }
    default {
        Write-Host "--! Profile not recognized! Exiting..." -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "--> PowerShell symlinks ..." -ForegroundColor Green

if ( -not (Test-Path "${env:USERPROFILE}\Documents\PowerShell")) { 
  New-Item -Path "${env:USERPROFILE}\Documents\PowerShell" -ItemType Directory
}

# PowerShell Core profile
if (Test-Path "${env:USERPROFILE}\Documents\PowerShell\Microsoft.PowerShell_profile.ps1") {
  Rename-Item -Path "${env:USERPROFILE}\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -NewName "Microsoft.PowerShell_profile.ps1_backup_${timeStamp}"
}
New-Item -Path "${env:USERPROFILE}\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -ItemType SymbolicLink -Value "${profilePath}\powershell\profile.ps1"

# Powershell Core aliases
if (Test-Path "${env:USERPROFILE}\Documents\PowerShell\aliases.ps1") {
  Rename-Item -Path "${env:USERPROFILE}\Documents\PowerShell\aliases.ps1" -NewName "aliases.ps1_backup_${timeStamp}" -Force
}
New-Item -Path "${env:USERPROFILE}\Documents\PowerShell\aliases.ps1" -ItemType SymbolicLink -Value "${profilePath}\powershell\aliases.ps1"

# Windows Terminal profile
# Install microsoft-windows-terminal, Always delete and place a new one
Write-Host "--> Windows Terminal symlinks ..." -ForegroundColor Green
$terminalFolder = Get-ChildItem "${env:USERPROFILE}\AppData\Local\Packages" -filter "Microsoft.WindowsTerminal_*" -Directory | ForEach-Object { $_.fullname }
if ($terminalFolder) {
  if (Test-Path "$terminalFolder\LocalState\settings.json") {
    #Remove-Item "$terminalFolder\LocalState\settings.json" -Force
    Rename-Item -Path "$terminalFolder\LocalState\settings.json" -NewName "settings.json_backup_${timeStamp}" -Force
  }
  New-Item -Path "$terminalFolder\LocalState\settings.json" -ItemType SymbolicLink -Value "${profilePath}\windows_terminal\settings.json"
}

# Gitconfig
Write-Host "--> Git symlinks ..." -ForegroundColor Green
if (Test-Path "${env:USERPROFILE}\.gitconfig") {
  Rename-Item -Path "${env:USERPROFILE}\.gitconfig" -NewName ".gitconfig_backup_${timeStamp}" -Force
}
New-Item -Path "${env:USERPROFILE}\.gitconfig" -ItemType SymbolicLink -Value "${profilePath}\git\.gitconfig"

# Create profile file for local override settings 
if ( -not (Test-Path "${env:USERPROFILE}\Documents\PowerShell\local_profile.ps1")) {
  New-Item -Path "${env:USERPROFILE}\Documents\PowerShell\local_profile.ps1" -ItemType "file" -Value ""
}

Read-Host -Prompt "Press Enter to exit" 