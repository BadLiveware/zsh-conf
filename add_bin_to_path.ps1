#Requires -RunasAdministrator

$Path = "$HOME\.config\bin"
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$Path", [System.EnvironmentVariableTarget]::User)