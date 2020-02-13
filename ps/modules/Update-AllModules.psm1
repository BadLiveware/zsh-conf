function Update-AllModules {
	$Modules = Get-Module -All
	$Modules | ForEach-Object { Update-Module -Name $_ -AllowPrerelease }
}
