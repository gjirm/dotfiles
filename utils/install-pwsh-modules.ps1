# ==============================================================================
# Install PowerShell modules used by Microsoft.PowerShell_profile.ps1
# Idempotent: modules already present are skipped (pass -Update to upgrade).
# Installs into PowerShell 7 (pwsh) CurrentUser scope, no admin needed.
# Called from the `bootstrap` task in config.win-*.toml, can be run manually.
# ==============================================================================
param(
    [switch]$Update
)

$ErrorActionPreference = 'Stop'

$modules = @(
    @{ Name = 'Terminal-Icons' }
    @{ Name = 'PSReadLine'; AllowPrerelease = $true }
    @{ Name = 'PSFzf' }
    @{ Name = 'PSEverything' }
    @{ Name = 'WslInterop' }
)

# Modules must land in PowerShell 7, re-launch under pwsh when started from
# Windows PowerShell 5.1 (mise tasks run before pwsh is on PATH).
if ($PSVersionTable.PSEdition -ne 'Core') {
    $pwshExe = Get-ChildItem -Path "$env:ProgramFiles\PowerShell\*\pwsh.exe" -ErrorAction SilentlyContinue |
        Select-Object -Last 1 -ExpandProperty FullName
    if (-not $pwshExe) { $pwshExe = (Get-Command pwsh -ErrorAction SilentlyContinue).Source }
    if (-not $pwshExe) {
        Write-Host "--! pwsh.exe not found, install Microsoft.PowerShell first" -ForegroundColor Red
        exit 1
    }
    & $pwshExe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $PSCommandPath @PSBoundParameters
    exit $LASTEXITCODE
}

if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') {
    Write-Host "--> Trusting PSGallery repository..." -ForegroundColor Green
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

# Only count CurrentUser installs, pwsh ships its own (older) PSReadLine
$userModules = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PowerShell\Modules'

foreach ($m in $modules) {
    $installed = Get-Module -ListAvailable -Name $m.Name |
        Where-Object { $_.ModuleBase -like "$userModules\*" }
    if ($installed -and -not $Update) {
        Write-Host "[ok] $($m.Name) already installed ($($installed[0].Version))" -ForegroundColor DarkGray
        continue
    }

    Write-Host "--> Installing $($m.Name)..." -ForegroundColor Green
    $params = @{
        Name               = $m.Name
        Scope              = 'CurrentUser'
        Force              = $true
        SkipPublisherCheck = $true
        AllowClobber       = $true
        AllowPrerelease    = [bool]$m.AllowPrerelease
    }
    Install-Module @params
}

# Files the profile expects to exist
$psDir = Split-Path $userModules
New-Item -ItemType Directory -Force -Path $psDir | Out-Null
$localProfile = Join-Path $psDir 'local_profile.ps1'
if (-not (Test-Path $localProfile)) {
    New-Item -ItemType File -Path $localProfile | Out-Null
}
