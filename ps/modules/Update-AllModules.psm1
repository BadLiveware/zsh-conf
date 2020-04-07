function Update-AllModules {
	param(
		[switch]
		$Force,
		[switch]
		$Verbose
	)
	Write-Host "Getting installed modules"
	Get-InstalledModule | Select-Object -ExpandProperty name | Tee-Object -Variable Modules | Write-Host -ForegroundColor Cyan
	Write-Host "Unloading modules"
	$Modules | Remove-Module -Verbose:$Verbose
	Write-Host "Updating modules"
	$Modules | ForEach-Object -Parallel { Update-Module -Name $_ -AllowPrerelease -Force:$Using:Force -Verbose:$Using:Verbose }
}
