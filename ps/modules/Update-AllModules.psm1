function Update-AllModules {
	$Modules = Get-InstalledModule | Select-Object -Property name
	Write-Host "Unloading modules"
	$Modules | Remove-Module -Verbose
	Write-Host "Updating modules"
	$Modules | Update-Module -AllowPrerelease -Force -Verbose
}
