
Import-Module posh-git
Import-Module oh-my-posh
Import-Module Get-ChildItemColor
Import-Module PSReadline

# Viz https://github.com/mikebattista/PowerShell-WSL-Interop
#Import-WslCommand "awk", "emacs", "grep", "head", "less", "man", "sed", "seq", "tail", "vim", "qrencode", "tee"

#$DefaultUser = 'jirm'

# Start the default settings
#Set-Prompt
# Alternatively set the desired theme:
Set-Theme Paradox

# Aliases
Import-Module "${env:USERPROFILE}\Documents\PowerShell\aliases.ps1"

# Start-SshAgent
# $env:ConEmuANSI = $True # hack for normal powershell

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
