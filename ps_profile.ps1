

# PSReadLine
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineOption -ShowToolTips

Import-Module -Name Get-ChildItemColor
# Set l and ls alias to use the new Get-ChildItemColor cmdlets
Set-Alias l Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope

Import-Module -Name posh-git
# Start SshAgent if not already
# Need this if you are using github as your remote git repository
# if (! (ps | ? { $_.Name -eq 'ssh-agent' })) {
#     Start-SshAgent
# }

Import-Module -Name oh-my-posh
Set-Theme Paradox

Remove-PSReadlineKeyHandler 'Ctrl+r'
Import-Module PSFzf

## Azure
Enable-AzureRmAlias



#### Functions

function touch {
    param ([parameter(Position = 0)][string] $Filename)
    New-Item -ItemType file $Filename
}
# Helper function to set location to the User Profile directory
function cUserProfile { Set-Location ~ }
Set-Alias ~ cUserProfile -Option AllScope

function cUserWorkspace { Set-Location ~/source }
Set-Alias cws cUserWorkspace -Option AllScope

Set-Alias fcd cde

Set-Alias lg lazygit



function fzf-invoke { Get-ChildItem | where-object { -not $_.PSIsContainer } | Invoke-Fzf | Invoke-Item }
Set-Alias finvoke fzf-invoke

function az-function-interact {
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
    Write-Host "Searching for apps..." -ForegroundColor Green
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
Set-Alias azfun az-function-interact
