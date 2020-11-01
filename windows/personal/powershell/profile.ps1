
Import-Module posh-git
Import-Module oh-my-posh
Import-Module Get-ChildItemColor
Import-Module PSReadline

# Viz https://github.com/mikebattista/PowerShell-WSL-Interop
Import-WslCommand "awk", "emacs", "grep", "head", "less", "man", "sed", "seq", "tail", "vim", "qrencode", "tee"


$DefaultUser = "$env:username"
# Start the default settings
#Set-Prompt
# PowerShell theme:
Set-Theme Paradox

# Start-SshAgent
# $env:ConEmuANSI = $True # hack for normal powershell

if (-not $env:HOME) {
    $env:HOME = "$($env:HOMEDRIVE)$($env:HOMEPATH)"
}

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Aliases
Import-Module "${env:USERPROFILE}\Documents\PowerShell\aliases.ps1"

# Local profile file
Import-Module "${env:USERPROFILE}\Documents\PowerShell\local_profile.ps1"
