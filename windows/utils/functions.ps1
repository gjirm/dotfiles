function InstallFromGithub {
    Param (
        [Parameter(Mandatory=$true)] [string]$repo,
        [Parameter(Mandatory=$true)] [string]$filenamePattern,
        [Parameter(Mandatory=$true)] [string]$installPath,
        [Parameter(Mandatory=$false)] [bool]$deleteExistingPath = $false,
        [Parameter(Mandatory=$false)] [bool]$setEnvPath = $false,
        [Parameter(Mandatory=$false)] [bool]$preRelease = $false
    )
    $lastexitcode = 0

    $installPath = Resolve-Path $installPath
    
    Write-Host "--> Downloading latest $repo from GitHub" -ForegroundColor Green

    if ($preRelease) {
        $releasesUri = "https://api.github.com/repos/$repo/releases"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $downloadUri = ((Invoke-RestMethod -Method GET -Uri $releasesUri)[0].assets | Where-Object name -like $filenamePattern ).browser_download_url
        #CheckExitCode -exitcode $lastexitcode -msg "$repo url fetch"
        Write-Host "--> Fetching pre-release download URL: $downloadUri" -ForegroundColor Green
    }
    else {
        $releasesUri = "https://api.github.com/repos/$repo/releases/latest"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $downloadUri = ((Invoke-RestMethod -Method GET -Uri $releasesUri).assets | Where-Object name -like $filenamePattern ).browser_download_url
        #CheckExitCode -exitcode $lastexitcode -msg "$repo url fetch"
        Write-Host "--> Fetching download URL:  $downloadUri" -ForegroundColor Green
    }

    $fileName = Split-Path -Path $downloadUri -Leaf
    $extension = $fileName.Split(".")[-1]   

    if (Test-Path "$installPath") {
        if ($deleteExistingPath) {
            Write-Host "--> Deleting existing install path: $installPath" -ForegroundColor Yellow
            Remove-Item -Path $installPath -Recurse -Force -ErrorAction SilentlyContinue
        }    
    } else {
        Write-Host "--> Install path does not exists - creating: $installPath" -ForegroundColor Yellow
        New-Item -Path $installPath -ItemType "directory" -Force | Out-Null
    }

    if ( $extension.ToLower() -eq "zip" ) {
        $pathZip = Join-Path -Path $([System.IO.Path]::GetTempPath()) -ChildPath $(Split-Path -Path $downloadUri -Leaf)

        Write-Host "--> Downloading $fileName to $pathZip" -ForegroundColor Green

        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            #Invoke-WebRequest -Uri $downloadUri -Out $pathZip
            (New-Object System.Net.WebClient).DownloadFile($downloadUri, $pathZip)
        }
        catch {
            Write-Host $Error[0] -ForegroundColor Red
            Write-Host "--> Downloading failed. Exiting..." -ForegroundColor Red
            exit 1
        }

        Write-Host "--> Extracting: $pathZip" -ForegroundColor Green
        #Unzip -zipfile $pathZip -out $installPath
        try { 
            Expand-Archive -LiteralPath $pathZip -DestinationPath $installPath -ErrorAction Stop
        }
        catch {
            Write-Host $Error[0] -ForegroundColor Red
            Write-Host "--> Unziping failed. Exiting..." -ForegroundColor Red
            exit 1
        }
        #CheckExitCode -exitcode $lastexitcode -msg "$pathZip unzip"
        Remove-Item $pathZip -Force

    } else {

        Write-Host "--> Downloading $fileName to $installPath\$fileName" -ForegroundColor Green

        if (Test-Path "$installPath\$fileName") {
            $deleteExistingFile = Read-Host -Prompt "$installPath\$fileName file exists. Rewrite? [y/n]" 
            $deleteExistingFile = $deleteExistingFile.ToLower()

            switch ($deleteExistingFile) {
                "y" {
                    Remove-Item -Path "$installPath\$fileName" -Force
                }
                default {
                    Write-Host "--! File exists. Exiting..." -ForegroundColor Yellow
                    exit 1
                }
            }
        }

        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            #Invoke-WebRequest -Uri $downloadUri -Out $installPath
            (New-Object System.Net.WebClient).DownloadFile($downloadUri, "$installPath\$fileName")
            #CheckExitCode -exitcode $lastexitcode -msg "$repo download"
        }
        catch {
            Write-Host $Error[0] -ForegroundColor Red
            Write-Host "--> Downloading failed. Exiting..." -ForegroundColor Red
            exit 1
        }

    }

    if ($setEnvPath) {
        $oldUserPath = [Environment]::GetEnvironmentVariable('path', 'user');
        if (-NOT ($oldUserPath -like "*$installPath*")) {
            Write-Host "--> Setting executable to user PATH variable..." -ForegroundColor Green
            $newUserPath = $oldUserPath  + ';' + $installPath
            [Environment]::SetEnvironmentVariable('path', $newUserPath,'user');
        }
        $oldMachinePath = [Environment]::GetEnvironmentVariable('path', 'machine');
        if (-NOT ($oldUserPath -like "*$installPath*")) {
            Write-Host "--> Setting executable to computer PATH variable..." -ForegroundColor Green
            $newMachinePath = $oldMachinePath + ';' + $installPath
            [Environment]::SetEnvironmentVariable('path', $newMachinePath,'machine');
        }
    }
    
    #Write-Host "--> Done" -ForegroundColor Green

}

# Example
#InstallFromGithub -repo "adam7/delugia-code" -filenamePattern "Delugia.Nerd.Font.Complete.ttf" -installPath "$PSScriptRoot"

# Winget install wrapper
function WingetInstall {
    winget install --exact $args --accept-source-agreements --accept-package-agreements 
}
