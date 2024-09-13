
Import-Module Terminal-Icons
Import-Module PSReadline
Import-Module PSFzf

# Aliases
Import-Module "${env:USERPROFILE}\Documents\PowerShell\aliases.ps1"

# Local profile file
Import-Module "${env:USERPROFILE}\Documents\PowerShell\local_profile.ps1"

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Fzf tab:
#Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
#Set-PsFzfOption -TabExpansion

Invoke-Expression ( &starship init powershell )
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Clear-Host
