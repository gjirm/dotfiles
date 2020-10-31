@echo off
setlocal enableDelayedExpansion

echo ##################################
echo ##   Installing chocolatey...   ##
echo ##################################
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

echo ##################################
echo ##   Installing Apps...         ##
echo ##################################
choco upgrade -y --not-broken --approved-only chocolateygui
:: choco upgrade -y --not-broken --approved-only googlechrome
choco upgrade -y --not-broken --approved-only firefox
::choco upgrade -y --not-broken --approved-only adobereader
choco upgrade -y --not-broken --approved-only doublecmd
::choco upgrade -y --not-broken --approved-only filezilla
choco upgrade -y --not-broken --approved-only 7zip.install
choco upgrade -y --not-broken --approved-only cyberduck
choco upgrade -y --not-broken --approved-only mountain-duck 
::choco upgrade -y --not-broken --approved-only winrar
choco upgrade -y --not-broken --approved-only gpg4win
::choco upgrade -y --not-broken --approved-only notepadplusplus.install
choco upgrade -y --not-broken --approved-only sysinternals
::choco upgrade -y --not-broken --approved-only autohotkey
::choco upgrade -y --not-broken --approved-only skype
choco upgrade -y --not-broken --approved-only python
::choco upgrade -y --not-broken --approved-only wget
::choco upgrade -y --not-broken --approved-only curl
choco upgrade -y --not-broken --approved-only vlc
choco upgrade -y --not-broken --approved-only jre8
choco upgrade -y --not-broken --approved-only openssl
::choco upgrade -y --not-broken --approved-only dropbox
choco upgrade -y --not-broken --approved-only spotify
choco upgrade -y --not-broken --approved-only vscode
choco upgrade -y --not-broken --approved-only git
::choco upgrade -y --not-broken --approved-only poshgit
choco upgrade -y --not-broken --approved-only github-desktop
choco upgrade -y --not-broken --approved-only keybase
::choco upgrade -y --not-broken --approved-only dropbox
choco upgrade -y --not-broken --approved-only micro

:: Make Dev Cert https://github.com/FiloSottile/mkcert
choco upgrade -y --not-broken --approved-only mkcert

:: Sign tool minisign/signify https://jedisct1.github.io/minisign/
choco upgrade -y --not-broken --approved-only minisign

:: Magic Wormhole https://github.com/warner/magic-wormhole
choco upgrade -y --not-broken --approved-only vcbuildtools
choco upgrade -y magic-wormhole --source=python
::choco upgrade -y --not-broken --approved-only mousewithoutborders
::choco upgrade -y --not-broken --approved-only keepass
::choco upgrade -y --not-broken --approved-only keepass-plugin-otpkeyprov
::choco upgrade -y --not-broken --approved-only keepass-plugin-keeagent
::choco upgrade -y --not-broken --approved-only keepass-plugin-keecloud
::choco upgrade -y --not-broken --approved-only keepass-plugin-keeotp
::choco upgrade -y --not-broken --approved-only keepass-plugin-keechallenge

:: LaTeX http://latex.feec.vutbr.cz/cz/latex/lokalni-instalace/
:: choco upgrade -y --not-broken --approved-only miktex
:: choco upgrade -y --not-broken --approved-only gsview
:: choco upgrade -y --not-broken --approved-only ghostscript.app
:: choco upgrade -y --not-broken --approved-only texniccenter
:: choco upgrade -y --not-broken --approved-only sumatrapdf.install

:: Cloud clients
::choco upgrade -y --not-broken --approved-only --not-broken --approved-only windowsazurepowershell
::choco upgrade -y --not-broken --approved-only --not-broken --approved-only azcopy
::choco upgrade -y --not-broken --approved-only --not-broken --approved-only microsoftazurestorageexplorer
choco upgrade -y --not-broken --approved-only --not-broken --approved-only awscli
::choco upgrade -y --not-broken --approved-only --not-broken --approved-only duck

::::::::::::::::::
:: Other Tools  ::
::::::::::::::::::
::choco upgrade -y --not-broken --approved-only openssh
::choco upgrade -y --not-broken --approved-only gnuwin32-sed.install
::choco upgrade -y --not-broken --approved-only rsync
::choco upgrade -y --not-broken --approved-only powershell
::choco upgrade -y --not-broken --approved-only marktext



echo ##################################
echo ##   Setting up Update Task...  ##
echo ##################################
@powershell -NoProfile -ExecutionPolicy Bypass -Command "&'%~dp0Schedule-ChocoUpgradeAll.ps1'"


echo ##################################
echo ##   Installing SDelete...      ##
echo ##################################
@powershell -NoProfile -ExecutionPolicy Bypass -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;(New-Object Net.WebClient).DownloadFile('https://cdn.safetica.com/files/install/sdelete/Install_sdelete.bat', 'install_sdelete.bat')}"
install_sdelete.bat
del install_sdelete.bat

:: echo ##################################
:: echo ##   Installing (s)up2transfer. ##
:: echo ##################################
:: @powershell -NoProfile -ExecutionPolicy Bypass -Command "(New-Object Net.WebClient).DownloadFile('https://cdn.safetica.com/files/install/sup2transfer/Install_sup2transfer.bat', 'install_sup2transfer.bat')"
:: install_sup2transfer.bat
:: del install_sup2transfer.bat

pause

exit
:: --not-broken --approved-only