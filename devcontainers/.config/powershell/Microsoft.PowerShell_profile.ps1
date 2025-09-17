
Import-Module Terminal-Icons
Import-Module PSReadline
Import-Module PSFzf

# Aliases

# Git
function g { git $args }
function gcl { git clone $args }
function gs { git status }
function gss { git status -s }
function gpp { 
    git pull
    git push
}
function gaa { git add -A $args }
function gcom { git commit -m $args }
function pull { git pull $args }
function push { git push $args }

Set-Alias -Name gpull -Value pull
Set-Alias -Name gpush -Value push
function gitpush {
    git add -A
    git commit -m "$args"
    git pull
    git push
}

Set-Alias l Get-ChildItem -Option AllScope
Set-Alias ll Get-ChildItem -Option AllScope
Set-Alias ls Get-ChildItem -Option AllScope
#Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope

# Directory
function .. { Set-Location .. }
function ... { Set-Location .. ; Set-Location .. }
function .... { Set-Location .. ; Set-Location .. ; Set-Location .. }
function ..... { Set-Location .. ; Set-Location .. ; Set-Location .. ; Set-Location .. }

function fcd { Set-Location -Path $(fd -HI -t d $args . | fzf) }

function mcd { New-Item $args[0] -ItemType Directory; Set-Location -Path $args[0] }

function fed { 
    Try {
        Get-ChildItem -Path . -Include "*$args*" -Recurse -Attributes !Directory | Invoke-Fzf | ForEach-Object { micro $_ }
    } Catch {
    }
}

function fco { 
    Try {
        Get-ChildItem -Path . -Include "*$args*" -Recurse -Attributes !Directory | Invoke-Fzf | ForEach-Object { code $_ }
    } Catch {
    }
}

# DNS
function rdns { Resolve-DnsName $args[0] }

# Terraform
function tf { terraform $args }

function tfp { terraform plan --out "$(Get-Date -Format "yyyy-MM-dd_HHmm").tfplan" }

#Others
function which($name) {
    Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition
}

function fs {
    if ($args) {
        ssh $(Get-Content "~/.ssh/config" | Select-String -pattern "Host .*$args.*" | ForEach-Object { $_.Matches.Value.Split()[1]} | Invoke-Fzf)
    } else {
        ssh $(Get-Content "~/.ssh/config" | Select-String -pattern "Host [^*]+$" | ForEach-Object { $_.Matches.Value.Split()[1]} | Invoke-Fzf)
    }
}

function rnd {
    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-$%&*#@?<>'
    if ($args) {
      -join (Get-Random -Minimum 0 -Maximum $chars.Length -Count $args[0] | ForEach-Object {$chars[$_]})
    } else {
      -join (Get-Random -Minimum 0 -Maximum $chars.Length -Count 16 | ForEach-Object {$chars[$_]})
    }
  }

function psake { 
.\Makefile.ps1 $args
}

function pst {
  curl -F "lesma=$input" "https://paste.jirm.cz"
}

  
Set-Alias -Name cde -Value Set-LocationFuzzyEverything
Set-Alias -Name lzd -Value lazydocker
  
Set-PSReadLineOption -MaximumHistoryCount 10000
Set-PSReadLineOption -HistorySavePath "/workspaces/_data/pwsh_history.txt"

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
