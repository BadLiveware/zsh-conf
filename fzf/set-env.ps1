Write-Host "Setting FZF_DEFAULT_OPTS to"
Get-Content ./fzf | Tee-Object -Variable Value | Write-Host 

[System.Environment]::SetEnvironmentVariable("FZF_DEFAULT_OPTS", $Value, "User")