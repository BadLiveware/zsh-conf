#Requires -RunAsAdministrator

$TargetDirectory = Join-Path $Env:LocalAppData "lf/"
if (-not (Test-Path -Path $TargetDirectory)) {
	Throw "The target directory $TargetDirectory does not exist"
}

Test-Path -Path $TargetDirectory && Throw "The target directory $TargetDirectory does not exist"

$TargetFile = Join-Path $TargetDirectory "lfrc"
if (-not (Test-Path -Path $TargetFile)) {
	Write-Host "Target file $TargetFile already exists, overwriting"
}

New-Item -ItemType SymbolicLink -Path "./lfrc" -Target $TargetFile -Force
