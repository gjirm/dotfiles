# Update .dotfiles
function update_dotfiles {
  Write-Host "--> Updating $env:userprofile\.dotfiles..." -ForegroundColor Green
  git -C "$env:userprofile\.dotfiles" restore .
  git -C "$env:userprofile\.dotfiles" pull  
}

# work git
function push_work {
  Write-Host "--> Pushing $env:MY_GITWORK_PATH..." -ForegroundColor Green
  $cDate = Get-Date -Format "yyyy-MM-dd_HHmmss_K"
  git -C "$env:MY_GITWORK_PATH" add -A
  git -C "$env:MY_GITWORK_PATH" commit -m "$cDate"
  git -C "$env:MY_GITWORK_PATH" pull
  git -C "$env:MY_GITWORK_PATH" push
}

function pull_work {
  Write-Host "--> Pulling $env:MY_GITWORK_PATH..." -ForegroundColor Green
  git -C "$env:MY_GITWORK_PATH" pull
}

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
Function cdssh {Set-Location -Path "$env:MY_SSH_PATH"}
Function cdgit {Set-Location -Path "$env:MY_GIT_PATH"}
Function cdwork {Set-Location -Path "$env:MY_WORK_PATH"}
Function cdgitwork {Set-Location -Path "$env:MY_GITWORK_PATH"}

function fcd { Set-Location -Path $(fd -HI -t d $args . | fzf) }

function mcd { New-Item $args[0] -ItemType Directory; Set-Location -Path $args[0] }

# Text editor
# function fed { micro $(fd -HI -t f -t l $args . | fzf) }
# function fco { code $(fd -HI -t f -t l $args . | fzf) }
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

#Others
function which($name) {
  Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition
}

# Replaced by https://github.com/lukesampson/psutils
# function touch($file) {
#   "" | Out-File $file -Encoding ASCII
# }

# Replaced by https://github.com/lukesampson/psutils
# function time {
#   Set-StrictMode -Off;

#   # see http://stackoverflow.com/a/3513669/87453
#   $cmd, $args = $args
#   $args = @($args)
#   $sw = [diagnostics.stopwatch]::startnew()
#   & $cmd @args
#   $sw.stop()
  
#   "$($sw.elapsed)"
# }

# function fss {
#     if ($args) {
#         $cmd = $(fd -t f -e ps1 $args "$env:MY_SSH_PATH" | fzf)
#         & $cmd
#     } else {
#         $cmd = $(fd -t f -e ps1 . "$env:MY_SSH_PATH" | fzf)
#         & $cmd
#     }
# }

function fss {
  if ($args) {
      $cmd = $(Get-ChildItem -Path "$env:MY_SSH_PATH" -Include "*$args*.ps1*" -Recurse -Attributes !Directory | Invoke-Fzf)
      & $cmd
  } else {
      $cmd = $(Get-ChildItem -Path "$env:MY_SSH_PATH" -Include "*.ps1*" -Recurse -Attributes !Directory  | Invoke-Fzf)
      & $cmd
  }
}

function fdc { 
  if ($args) {
    & "C:\Program Files\Double Commander\doublecmd.exe" -c -t $(fd -HI -t d $args . | fzf) 
  } else {
    & "C:\Program Files\Double Commander\doublecmd.exe" -c -t . 
  }
}

function dc { 
  if ($args) {
    & "C:\Program Files\Double Commander\doublecmd.exe" -c -t $args
  } else {
    & "C:\Program Files\Double Commander\doublecmd.exe" -c -t .
  }
}

function fex { 
  if ($args) {
    & explorer $(fd -HI -t d $args . | fzf) 
  } else {
    & explorer .
  }
}

# Sudo - replaced by https://github.com/lukesampson/psutils
# function elevateProcess {
#   & Start-Process pwsh.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command ""${args}""" -Verb RunAs
# }
# Set-Alias -Name sudo -Value elevateProcess

function Set-Hosts {
  sudo notepad "$($env:SystemRoot)\system32\drivers\etc\hosts"
}
Set-Alias -Name hosts -Value Set-Hosts
