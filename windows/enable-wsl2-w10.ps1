#Requires -RunAsAdministrator

# On Windows 10
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2