Write-Host "Setting BAT_CONFIG_PATH to"
Get-Content ./bat | Tee-Object -Variable Value | Write-Host 

[System.Environment]::SetEnvironmentVariable("FZF_DEFAULT_OPTS", $Value, "User")