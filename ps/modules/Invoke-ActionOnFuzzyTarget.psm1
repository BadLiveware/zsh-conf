function Invoke-ActionOnFuzzyTarget {
	param (

		[Parameter(Mandatory = $true, Position = 0, ValueFromPipeline)]
		$Action,
		[Parameter(Position = 1, ValueFromRemainingArguments)]
		[string[]]
		$RemainingArgs
	)
	$Targets = Get-ChildItem -recurse -depth 3

	$SelectedTargets = $Targets | Invoke-Fzf -Multi 
	
	Write-Host "Executing:" -ForegroundColor Blue
	$SelectedTargets | Foreach-Object { Write-Host $Action $_ $RemainingArgs -ForegroundColor Yellow }
	Write-Host

	$SelectedTargets | ForEach-Object { 
		if ($null -eq $RemainingArgs) { 
			& $Action $_
		}
		else {
			& $Action $_ $RemainingArgs
		}
	}		
}