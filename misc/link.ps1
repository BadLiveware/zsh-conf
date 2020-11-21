#Requires -RunAsAdministrator

$Startup = "$([Environment]::GetFolderPath('Startup'))"

$GuidClipboard = Join-Path $PSScriptRoot .\Guid-Clipboard.ahk
New-Item -ItemType SymbolicLink -Path $Startup -Name "GuidClipboard" -Value $GuidClipboard -Force
#REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /V "Guid-Clipboard AHK Script" /t REG_SZ /F /D "$Target"


$AlwaysOnTop = Join-Path $PSScriptRoot .\AlwaysOnTop.ahk
New-Item -ItemType SymbolicLink -Path $Startup -Name "AlwaysOnTop" -Value $AlwaysOnTop -Force
# REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /V "AlwaysOnTop AHK Script" /t REG_SZ /F /D "$Target"

