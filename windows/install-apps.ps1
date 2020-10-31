#Requires -RunAsAdministrator

function ChocoInstall {
  choco upgrade -y --not-broken --approved-only $args
}

if( -not (test-path "C:\ProgramData\chocolatey\choco.exe") ) {
    Write-Host "--> Installing chocolatey..." -ForegroundColor Green
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

Write-Host "--> Installing Apps..." -ForegroundColor Green

ChocoInstall chocolateygui
# ChocoInstall googlechrome
ChocoInstall firefox
#ChocoInstall adobereader
ChocoInstall doublecmd
#ChocoInstall filezilla
ChocoInstall 7zip.install
ChocoInstall cyberduck
ChocoInstall mountain-duck 
#ChocoInstall winrar
ChocoInstall gpg4win
#ChocoInstall notepadplusplus.install
ChocoInstall sysinternals
#ChocoInstall autohotkey
#ChocoInstall skype
ChocoInstall python
#ChocoInstall wget
#ChocoInstall curl
ChocoInstall vlc
ChocoInstall jre8
ChocoInstall openssl
#ChocoInstall dropbox
ChocoInstall spotify
ChocoInstall vscode
ChocoInstall git
#ChocoInstall poshgit
ChocoInstall github-desktop
ChocoInstall keybase
#ChocoInstall dropbox
ChocoInstall micro
ChocoInstall powershell-core
ChocoInstall microsoft-windows-terminal

# Make Dev Cert https://github.com/FiloSottile/mkcert
#ChocoInstall mkcert

# Sign tool minisign/signify https://jedisct1.github.io/minisign/
ChocoInstall minisign

# Magic Wormhole https://github.com/warner/magic-wormhole
# ChocoInstall vcbuildtools
# choco upgrade -y magic-wormhole --source=python
#ChocoInstall mousewithoutborders
ChocoInstall keepass
#ChocoInstall keepass-plugin-otpkeyprov
#ChocoInstall keepass-plugin-keeagent
#ChocoInstall keepass-plugin-keecloud
#ChocoInstall keepass-plugin-keeotp
#ChocoInstall keepass-plugin-keechallenge

# LaTeX http://latex.feec.vutbr.cz/cz/latex/lokalni-instalace/
# ChocoInstall miktex
# ChocoInstall gsview
# ChocoInstall ghostscript.app
# ChocoInstall texniccenter
# ChocoInstall sumatrapdf.install

# Cloud clients
#ChocoInstall --not-broken --approved-only windowsazurepowershell
#ChocoInstall --not-broken --approved-only azcopy
#ChocoInstall --not-broken --approved-only microsoftazurestorageexplorer
ChocoInstall --not-broken --approved-only awscli
#ChocoInstall --not-broken --approved-only duck
choco install minio-client

# Other Tools 
#ChocoInstall openssh
#ChocoInstall gnuwin32-sed.install
#ChocoInstall rsync
#ChocoInstall powershell
#ChocoInstall marktext

Write-Host "--> Setting up Update Task..." -ForegroundColor Green

# See if choco.exe is available. If not, stop execution
$chocoCmd = Get-Command -Name 'choco' -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Select-Object -ExpandProperty Source
if ($null -eq $chocoCmd) { 
    break
}

# Setting up PS cmdlets for Scheduled Tasks
mofcomp C:\Windows\System32\wbem\SchedProv.mof

# Settings for the scheduled task
$taskAction = New-ScheduledTaskAction $chocoCmd -Argument 'upgrade all -y'
$taskTrigger = @()
$taskTrigger += New-ScheduledTaskTrigger -Weekly -At 9am -DaysOfWeek Wednesday -WeeksInterval 1 
$taskTrigger += New-ScheduledTaskTrigger -Weekly -At 4pm -DaysOfWeek Wednesday -WeeksInterval 1
$taskUserPrincipal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -RunLevel Highest
$taskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8 -AllowStartIfOnBatteries -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Hours 12)

# Set up the task, and register it
$task = New-ScheduledTask -Action $taskAction -Principal $taskUserPrincipal -Trigger $taskTrigger -Settings $taskSettings
Register-ScheduledTask -TaskName 'ChocolateyUpgradeAllTask' -InputObject $task -Force

Write-Host "--> Done <--" -ForegroundColor Green
