# Set ENV variables for MY common paths
$setSshEnv = Read-Host -Prompt "--> Set ENV variable with path to folder with SSH profiles (MY_SSH_PATH)"
if ($setSshEnv) {
  [Environment]::SetEnvironmentVariable("MY_SSH_PATH", "$setSshEnv","user")
  Write-Host "--> Variable MY_SSH_PATH set" -ForegroundColor Green

}

$setWorkEnv = Read-Host -Prompt "--> Set ENV variable with path to folder with WORK files (MY_WORK_PATH)"
if ($setWorkEnv) {
  [Environment]::SetEnvironmentVariable("MY_WORK_PATH", "$setWorkEnv","user")
  Write-Host "--> Variable MY_WORK_PATH set" -ForegroundColor Green
}

$setWorkGirEnv = Read-Host -Prompt "--> Set ENV variable with path to folder with WORK GIT (MY_GITWORK_PATH)"
if ($setWorkGirEnv) {
  [Environment]::SetEnvironmentVariable("MY_GITWORK_PATH", "$setWorkGirEnv","user")
  Write-Host "--> Variable MY_GITWORK_PATH set" -ForegroundColor Green
}

$setAppsEnv = Read-Host -Prompt "--> Set ENV variable with path to the my portable APPS folder (MY_GIT_PATH)"
if ($setAppsEnv) {
  [Environment]::SetEnvironmentVariable("MY_APPS_PATH", "$setAppsEnv","user")
  Write-Host "--> Variable MY_APPS_PATH set" -ForegroundColor Green
}

Read-Host -Prompt "Press Enter to exit" 
