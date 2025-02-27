
#Import-Module posh-git
#Import-Module oh-my-posh
#Import-Module Get-ChildItemColor
Import-Module Terminal-Icons
Import-Module PSReadline
Import-Module PSFzf
Import-Module PSEverything 

# Aliases
Import-Module "${env:USERPROFILE}\Documents\PowerShell\aliases.ps1"

# Local profile file
Import-Module "${env:USERPROFILE}\Documents\PowerShell\local_profile.ps1"

# Viz https://github.com/mikebattista/PowerShell-WSL-Interop
Import-WslCommand "awk", "emacs", "grep", "head", "less", "man", "sed", "seq", "tail", "vim", "qrencode", "tee";

# Start-SshAgent

if (-not $env:HOME) {
    $env:HOME = "$($env:HOMEDRIVE)$($env:HOMEPATH)"
}

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Fzf tab:
#Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PSFzfOption -EnableAliasFuzzySetEverything -EnableAliasFuzzyGitStatus -EnableAliasFuzzyEdit -EnableAliasFuzzySetLocation -EnableAliasFuzzyHistory
#Set-PsFzfOption -TabExpansion

Invoke-Expression ( &starship init powershell )
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Clear-Host
