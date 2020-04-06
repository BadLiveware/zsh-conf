Write-Host "Setting STARSHIP_CONFIG to"
$PSScriptRoot | Tee-Object -Variable Value | Write-Host 

[System.Environment]::SetEnvironmentVariable("STARSHIP_CONFIG", $Value, "User")