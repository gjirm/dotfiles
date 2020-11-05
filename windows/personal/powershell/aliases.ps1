
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

Set-Alias l Get-ChildItemColor -Option AllScope
Set-Alias ll Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope

# Directory
function .. { cd .. }
function ... { cd .. ; cd .. }
function .... { cd .. ; cd .. ; cd .. }
function ..... { cd .. ; cd .. ; cd .. ; cd .. }
function home { cd $env:USERPROFILE }
function med { micro $(fd -HI -t f $args . | fzf) }

# Terraform
function tf { terraform $args }

#Others
function which($name) {
  Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition
}

function touch($file) {
  "" | Out-File $file -Encoding ASCII
}

function fed { micro $(fd -HI -t f $args . | fzf) }
function fss {
    if ($args) {
        $cmd = $(fd -t f -e ps1 $args D:\git\keybase\work\ssh | fzf)
        & $cmd
    } else {
        $cmd = $(fd -t f -e ps1 . D:\git\keybase\work\ssh | fzf)
        & $cmd
    }
}

# Sudo
function elevateProcess {
  & Start-Process pwsh.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command ""${args}""" -Verb RunAs
}
Set-Alias -Name sudo -Value elevateProcess

function Set-Hosts {
  sudo notepad "$($env:SystemRoot)\system32\drivers\etc\hosts"
}
Set-Alias -Name hosts -Value Set-Hosts
