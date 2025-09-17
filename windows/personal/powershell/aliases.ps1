# Update .dotfiles
function update_dotfiles {
  Write-Host "--> Updating $env:userprofile\.dotfiles..." -ForegroundColor Green
  git -C "$env:userprofile\.dotfiles" restore .
  git -C "$env:userprofile\.dotfiles" pull  
}

function starship_prompt {
  $starshipPromptFolder = "\.dotfiles\windows\personal\starship\"

  $newStarshipPrompt = $(Get-ChildItem -Path "$env:userprofile\$starshipPromptFolder" | Invoke-Fzf | ForEach-Object { Split-Path $_ -Leaf })

  $ENV:STARSHIP_CONFIG = $env:userprofile + $starshipPromptFolder + $newStarshipPrompt

  Write-Host "--> Saving new Starship prompt $newStarshipPrompt to local_profile.ps1.." -ForegroundColor Green
  $localProfile = "$env:userprofile\Documents\PowerShell\local_profile.ps1"

  # Define the search string and the replacement line
  $searchString = '$env:STARSHIP_CONFIG'

  $newStarshipPrompt = $searchString +' = "$env:userprofile' + $starshipPromptFolder + $newStarshipPrompt + '"'

  # Read all lines from the file
  $content = Get-Content $localProfile

  # Replace the line containing the search string
  $found = $false
  $updatedContent = $content | ForEach-Object {
      if ($_ -like "*$searchString*") {
          $found = $true
          $newStarshipPrompt
      } else {
          $_
      }
  }

  if (-not $found) {
      $updatedContent += $newStarshipPrompt
  }

  # Write the updated content back to the file
  $updatedContent | Set-Content $localProfile
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

function ezadir {
  eza -l --icons=auto --group-directories-first
}

Set-Alias -Name ll -Value ezadir
Set-Alias -Name ls -Value ezadir
Set-Alias -Name l -Value ezadir
# Set-Alias ll Get-ChildItem -Option AllScope
#Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope

# Directory
function .. { Set-Location .. }
function ... { Set-Location .. ; Set-Location .. }
function .... { Set-Location .. ; Set-Location .. ; Set-Location .. }
function ..... { Set-Location .. ; Set-Location .. ; Set-Location .. ; Set-Location .. }
function home { Set-Location $env:USERPROFILE }
Function cdssh {Set-Location -Path "$env:MY_SSH_PATH"}
Function cdgit {Set-Location -Path "$env:MY_GIT_PATH"}
Function cdwork {Set-Location -Path "$env:MY_WORK_PATH"}
Function cdgitwork {Set-Location -Path "$env:MY_GITWORK_PATH"}

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

function tfp { terraform plan --out "$(Get-Date -Format "yyyy-MM-dd_HHmm").tfplan" }

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

function fs {
  if ($args) {
    ssh $(Get-Content "$env:USERPROFILE\.ssh\config" | Select-String -pattern "Host .*$args.*" | ForEach-Object { $_.Matches.Value.Split()[1]} | Invoke-Fzf)
  } else {
    ssh $(Get-Content "$env:USERPROFILE\.ssh\config" | Select-String -pattern "Host [^*]+$" | ForEach-Object { $_.Matches.Value.Split()[1]} | Invoke-Fzf)
  }
}

function stss {
  if ($args) {
    wt -w 0 sp pwsh -Command fss $args[0]
    fss $args[0]
  } else {
    wt -w 0 sp pwsh -Command fss
    fss
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
    & "C:\Program Files\Double Commander\doublecmd.exe" -c -t .
}

function fex { 
    & explorer .
}

function rnd {
  $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-$%&*#@?<>'
  if ($args) {
    -join (Get-Random -Minimum 0 -Maximum $chars.Length -Count $args[0] | ForEach-Object {$chars[$_]})
  } else {
    -join (Get-Random -Minimum 0 -Maximum $chars.Length -Count 16 | ForEach-Object {$chars[$_]})
  }
}

function rnda {
  $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
  if ($args) {
    -join (Get-Random -Minimum 0 -Maximum $chars.Length -Count $args[0] | ForEach-Object {$chars[$_]})
  } else {
    -join (Get-Random -Minimum 0 -Maximum $chars.Length -Count 16 | ForEach-Object {$chars[$_]})
  }
}

function bwp {
  # Using Bitwarden CIL
  if ($args) {
    bw generate --passphrase --words $args[0] --separator - --includeNumber --capitalize
  } else {
    bw generate --passphrase --words 3 --separator - --includeNumber --capitalize
  }
}

function yy {
  $tmp = [System.IO.Path]::GetTempFileName()
  yazi $args --cwd-file="$tmp"
  $cwd = Get-Content -Path $tmp
  if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
      Set-Location -Path $cwd
  }
  Remove-Item -Path $tmp
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

Set-Alias -Name pstp -Value "curl -F 'lesma=<-' 'https://paste.jirm.cz'"

function psake { 
  .\Makefile.ps1 $args
}

Set-Alias -Name lzd -Value lazydocker

function npp { & "C:\Program Files\Notepad++\notepad++.exe" $args }

function pst {
  curl -F "lesma=$input" "https://paste.jirm.cz"
}
