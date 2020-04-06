#Requires -RunAsAdministrator

$TargetDirectory = Join-Path $Env:LocalAppData "lf/"
if (-not (Test-Path -Path $TargetDirectory)) {
	Write-Error "The target directory $TargetDirectory does not exist" -ErrorAction Stop
}

Test-Path -Path $TargetDirectory && Write-Error "The target directory $TargetDirectory does not exist" -ErrorAction SilentlyContinue

$TargetFile = Join-Path $TargetDirectory "lfrc"
if (-not (Test-Path -Path $TargetFile)) {
	Write-Host "Target file $TargetFile already exists, overwriting"
}

New-Item -ItemType HardLink -Path $TargetFile -Target "./lfrc" -Force
