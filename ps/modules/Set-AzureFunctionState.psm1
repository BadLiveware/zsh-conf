function Set-AzureFunctionState {
    #Requires -Module PSFzf
    #Requires -Assembly 'az'
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        [ValidateSet("stop", "start", "restart", "show")]
        $Action,
        
        [Parameter(Mandatory = $false, Position = 1)]
        [string]
        [ValidateSet("running", "stopped")]
        $State
    )
    Write-Host "Fetching apps..." -ForegroundColor Green
    $apps = az functionapp list --output json | convertfrom-json -AsHashtable
    
    if ($state) { 
        $apps = $apps | where-object { $_.state -like $State }
    }

    if (!$apps) {
        Write-Error "Found no apps"
        return;
    }
    
    $selectedNames = $apps | select-object -Property name, id, resourcegroup | sort-object resourcegroup | invoke-fzf -Multi
    if (-not $selectedNames) {
        Write-Error "No valid input select from fzf"
        return;
    }

    Write-Host "Sending commands..." -ForegroundColor Green
    $selectedApps = $apps | where-object { $_.name -in $selectedNames }
    if ($selectedApps) { 
        $appIds = $selectedApps.id
        az functionapp $Action --ids $appIds
        Write-Host "Performed $Action on "
        $selectedNames | format-table @{label = "Name"; Expression = { $_ } }
    }
    else { 
        Write-Error "No valid selected app found"
    }
}