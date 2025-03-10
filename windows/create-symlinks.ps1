#Requires -RunAsAdministrator

$timeStamp = Get-Date -Format "yyyy-MM-dd_HHmmss"

Write-Host "--> Creating profile symlinks <--" -ForegroundColor Green

# if ( -not $systemProfile) {
#   $systemProfile = Read-Host -Prompt "--> Enter the system profile type - personal"
# }

# switch ($systemProfile) {
#     "personal" {
#         $profilePath = "$PSScriptRoot\personal"
#     }
#     default {
#         Write-Host "--! Profile not recognized! Exiting..." -ForegroundColor Yellow
#         exit 1
#     }
# }

$profilePath = "$PSScriptRoot\personal"

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

# Create profile file for local override of powershell settings 
Write-Host "--> Create PowerShell Core local profile override file ${env:USERPROFILE}\Documents\PowerShell\local_profile.ps1 ..." -ForegroundColor Green
if ( -not (Test-Path "${env:USERPROFILE}\Documents\PowerShell\local_profile.ps1")) {
  New-Item -Path "${env:USERPROFILE}\Documents\PowerShell\local_profile.ps1" -ItemType "file" -Value ""
}

# Windows Terminal profile
# Install microsoft-windows-terminal, Always delete and place a new one
# Write-Host "--> Windows Terminal symlinks ..." -ForegroundColor Green
# $terminalFolder = Get-ChildItem "${env:USERPROFILE}\AppData\Local\Packages" -filter "Microsoft.WindowsTerminal_*" -Directory | ForEach-Object { $_.fullname }
# if ($terminalFolder) {
#   if (Test-Path "$terminalFolder\LocalState\settings.json") {
#     #Remove-Item "$terminalFolder\LocalState\settings.json" -Force
#     Rename-Item -Path "$terminalFolder\LocalState\settings.json" -NewName "settings.json_backup_${timeStamp}" -Force
#   }
#   New-Item -Path "$terminalFolder\LocalState\settings.json" -ItemType SymbolicLink -Value "${profilePath}\windows_terminal\settings.json"
# }

# Gitconfig
#Write-Host "--> Git symlinks ..." -ForegroundColor Green
#if (Test-Path "${env:USERPROFILE}\.gitconfig") {
#  Rename-Item -Path "${env:USERPROFILE}\.gitconfig" -NewName ".gitconfig_backup_${timeStamp}" -Force
#}
#New-Item -Path "${env:USERPROFILE}\.gitconfig" -ItemType SymbolicLink -Value "${profilePath}\git\.gitconfig"

# Starship prompt config
Write-Host "--> Starship prompt symlinks ..." -ForegroundColor Green

if (!(Test-Path "${env:USERPROFILE}\.config")) {
  New-Item -ItemType Directory -Force -Path "${env:USERPROFILE}\.config"
}

if (Test-Path "${env:USERPROFILE}\.config\starship.toml") {
  Rename-Item -Path "${env:USERPROFILE}\.config\starship.toml" -NewName "starship_backup_${timeStamp}.toml" -Force
} 
New-Item -Path "${env:USERPROFILE}\.config\starship.toml" -ItemType SymbolicLink -Value "${profilePath}\starship\starship.toml"


Write-Host "--> Yazi prompt symlinks ..." -ForegroundColor Green

if (!(Test-Path "${env:USERPROFILE}\AppData\Roaming\yazi\config")) {
  New-Item -ItemType Directory -Force -Path "${env:USERPROFILE}\AppData\Roaming\yazi\config"
}

if (Test-Path "${env:USERPROFILE}\AppData\Roaming\yazi\config\init.lua") {
  Rename-Item -Path "${env:USERPROFILE}\AppData\Roaming\yazi\config\init.lua" -NewName "init_${timeStamp}.lua" -Force
} 
New-Item -Path "${env:USERPROFILE}\AppData\Roaming\yazi\config\init.lua" -ItemType SymbolicLink -Value "${profilePath}\yazi\config\init.lua"

if (Test-Path "${env:USERPROFILE}\AppData\Roaming\yazi\config\keymap.toml") {
  Rename-Item -Path "${env:USERPROFILE}\AppData\Roaming\yazi\config\keymap.toml" -NewName "keymap_${timeStamp}.toml" -Force
} 
New-Item -Path "${env:USERPROFILE}\AppData\Roaming\yazi\config\keymap.toml" -ItemType SymbolicLink -Value "${profilePath}\yazi\config\keymap.toml"

if (Test-Path "${env:USERPROFILE}\AppData\Roaming\yazi\config\yazi.toml") {
  Rename-Item -Path "${env:USERPROFILE}\AppData\Roaming\yazi\config\yazi.toml" -NewName "yazi_${timeStamp}.toml" -Force
} 
New-Item -Path "${env:USERPROFILE}\AppData\Roaming\yazi\config\yazi.toml" -ItemType SymbolicLink -Value "${profilePath}\yazi\config\yazi.toml"

Read-Host -Prompt "Press Enter to exit" 