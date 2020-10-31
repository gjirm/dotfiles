
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

if ( -not (Test-Path "${env:USERPROFILE}\Documents\PowerShell")) { 
  New-Item -Path "${env:USERPROFILE}\Documents\PowerShell" -ItemType Directory
}

New-Item -Path "${env:USERPROFILE}\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -ItemType SymbolicLink -Value "${profilePath}\powershell\profile.ps1"

New-Item -Path "${env:USERPROFILE}\Documents\PowerShell\aliases.ps1" -ItemType SymbolicLink -Value "${profilePath}\powershell\aliases.ps1"
