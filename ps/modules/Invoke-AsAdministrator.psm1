function Invoke-AsAdministrator {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[string]
		$Action,
		[Parameter(Position = 1, ValueFromRemainingArguments)]
		[string[]]
		$RestArgs
	)

	Write-Host "Running: $Action $RestArgs"

	if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
		return Start-Process PowerShell -PassThru -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"$Action $RestArgs`"";
	}
	Write-Host "You are already administrator, dummy"
}
