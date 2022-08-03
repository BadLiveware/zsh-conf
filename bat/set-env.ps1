#Requires -RunasAdministrator

Write-Host "Setting BAT_CONFIG_PATH to"
Resolve-Path  ./bat | Select-Object -ExpandProperty Path | Tee-Object -Variable Value | Write-Host 

[System.Environment]::SetEnvironmentVariable("BAT_CONFIG_PATH", $Value, "User")