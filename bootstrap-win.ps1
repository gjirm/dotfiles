# ==============================================================================
# Workstation Bootstrap (Mise) - Windows
# Windows counterpart of bootstrap.sh. Run as a regular user (no admin),
# winget asks for elevation itself when a package needs it.
#
#   .\bootstrap-win.ps1 [-ProfileName win-personal|win-work] [-Yes]
#
# or straight from GitHub (works in Windows PowerShell 5.1 too):
#   irm https://raw.githubusercontent.com/gjirm/dotfiles/mise/bootstrap-win.ps1 | iex
#   & ([scriptblock]::Create((irm https://raw.githubusercontent.com/gjirm/dotfiles/mise/bootstrap-win.ps1))) -ProfileName win-work -Yes
#
# -Yes (or $env:BOOTSTRAP_YES = '1') passes --yes to `mise bootstrap` so it
# runs without confirmation prompts.
# ==============================================================================
param(
    [ValidateSet('win-personal', 'win-work')]
    [string]$ProfileName,

    [switch]$Yes
)

$ErrorActionPreference = 'Stop'

$DotfilesRepo = 'gjirm/dotfiles'
$DotfilesDir = Join-Path $HOME '.config\mise'

function Update-SessionPath {
    # Pick up PATH changes made by winget installs without restarting the shell
    $env:Path = @(
        [Environment]::GetEnvironmentVariable('Path', 'Machine')
        [Environment]::GetEnvironmentVariable('Path', 'User')
    ) -join ';'
}

function Install-WingetPackage([string]$Id) {
    winget install --exact --id $Id --silent --accept-source-agreements --accept-package-agreements
    # -1978335189 = APPINSTALLER_CLI_ERROR_UPDATE_NOT_APPLICABLE (already installed)
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335189) {
        throw "winget install $Id failed with exit code $LASTEXITCODE"
    }
    Update-SessionPath
}

Write-Host "=================================================================="
Write-Host "Workstation Bootstrap (Mise) - Windows"
Write-Host "=================================================================="
Write-Host ""

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget not found. Install 'App Installer' from the Microsoft Store first."
}

# Allow running local scripts (PowerShell profile, mise activation)
if ((Get-ExecutionPolicy -Scope CurrentUser) -notin 'RemoteSigned', 'Unrestricted', 'Bypass') {
    Write-Host "[-] Setting CurrentUser execution policy to RemoteSigned..."
    try {
        Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
    } catch {
        Write-Warning "Could not set execution policy (overridden by group policy?): $_"
    }
}

# ------------------------------------------------------------------------------
# 1. Install Git & Mise
# ------------------------------------------------------------------------------
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[-] Installing Git..."
    Install-WingetPackage 'Git.Git'
    Write-Host "[ok] Git installed"
} else {
    Write-Host "[ok] Git is already installed"
}

if (-not (Get-Command mise -ErrorAction SilentlyContinue)) {
    Write-Host "[-] Installing Mise..."
    Install-WingetPackage 'jdx.mise'
    Write-Host "[ok] Mise installed"
} else {
    Write-Host "[ok] Mise is already installed"
}

if (-not (Get-Command mise -ErrorAction SilentlyContinue)) {
    throw "mise not found on PATH after install. Open a new terminal and re-run this script."
}

# ------------------------------------------------------------------------------
# 2. Select Machine Purpose (Personal vs Work)
# ------------------------------------------------------------------------------
if (-not $ProfileName) {
    Write-Host ""
    Write-Host "Select the configuration profile for this machine:"
    Write-Host "  1) Personal (Windows) [Default]"
    Write-Host "  2) Work (Windows)"
    $choice = Read-Host "Enter choice [1/2, default: 1]"

    $ProfileName = switch ($choice) {
        { $_ -in '2', 'work', 'win-work' } { 'win-work' }
        default { 'win-personal' }
    }
}
Write-Host "[ok] Selected profile (-E $ProfileName)"

# ------------------------------------------------------------------------------
# 3. Clone dotfiles & run mise bootstrap
# ------------------------------------------------------------------------------
if (-not (Test-Path (Join-Path $DotfilesDir '.git'))) {
    Write-Host "[-] Cloning dotfiles repo into $DotfilesDir..."
    git clone --branch mise "https://github.com/$DotfilesRepo.git" $DotfilesDir
    if ($LASTEXITCODE -ne 0) { throw "git clone failed" }
} else {
    Write-Host "[ok] $DotfilesDir is already a git checkout"
}

# mise's global environment selection, so future `mise` calls load
# config.<profile>.toml without -E. Gitignored. Written here because
# [bootstrap.files] is only supported on Unix.
$miserc = Join-Path $DotfilesDir 'miserc.toml'
Write-Host "[-] Writing $miserc (env = $ProfileName)..."
[IO.File]::WriteAllText($miserc, "env = [`"$ProfileName`"]`n")

Push-Location $DotfilesDir
try {
    Write-Host "[-] Running bootstrap..."
    $bootstrapArgs = @('--adopt', $DotfilesRepo)
    if ($Yes -or $env:BOOTSTRAP_YES -eq '1') { $bootstrapArgs += '--yes' }
    mise -E $ProfileName bootstrap @bootstrapArgs
    if ($LASTEXITCODE -ne 0) { throw "mise bootstrap failed with exit code $LASTEXITCODE" }
} finally {
    Pop-Location
}

Write-Host ""
Write-Host "[ok] Bootstrap finished. Open a new PowerShell 7 terminal to load the profile." -ForegroundColor Green
