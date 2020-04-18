#Requires -RunAsAdministrator

$Target = Join-Path $PSScriptRoot .\Guid-Clipboard.ahk
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /V "Guid-Clipboard AHK Script" /t REG_SZ /F /D "$Target"

