#Requires -RunAsAdministrator

if ( -not $systemProfile) {
  $systemProfile = Read-Host -Prompt "--> Enter the system profile type - personal"
}

switch ($systemProfile) {
    "personal" {
        $profilePath = (Get-Item ".").FullName + "\personal"
    }
    default {
        Write-Host "--! Profile not recognized! Exiting..." -ForegroundColor Yellow
        exit 1
    }
}

if ( -not (Test-Path "${env:USERPROFILE}\Documents\PowerShell")) { 
  New-Item -Path "${env:USERPROFILE}\Documents\PowerShell" -ItemType Directory
}

# PowerShell Core profile
if (Test-Path "${env:USERPROFILE}\Documents\PowerShell\Microsoft.PowerShell_profile.ps1") {
  Rename-Item -Path "${env:USERPROFILE}\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -NewName "Microsoft.PowerShell_profile.ps1_backup"
}
New-Item -Path "${env:USERPROFILE}\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -ItemType SymbolicLink -Value "${profilePath}\powershell\profile.ps1"

# Powershell Core aliases
if (Test-Path "${env:USERPROFILE}\Documents\PowerShell\aliases.ps1") {
  Rename-Item -Path "${env:USERPROFILE}\Documents\PowerShell\aliases.ps1" -NewName "aliases.ps1_backup"
}
New-Item -Path "${env:USERPROFILE}\Documents\PowerShell\aliases.ps1" -ItemType SymbolicLink -Value "${profilePath}\powershell\aliases.ps1"

# Windows Terminal profile
# Install microsoft-windows-terminal, Always delete and place a new one
$terminalFolder = Get-ChildItem "${env:USERPROFILE}\AppData\Local\Packages" -filter "Microsoft.WindowsTerminal_*" -Directory | ForEach-Object { $_.fullname }
if ($terminalFolder) {
  if (Test-Path "$terminalFolder\LocalState\settings.json") {
    Remove-Item "$terminalFolder\LocalState\settings.json" -Force
  }
  New-Item -Path "$terminalFolder\LocalState\settings.json" -ItemType SymbolicLink -Value "${profilePath}\windows_terminal\settinga.json"
}
