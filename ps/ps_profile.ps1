# PSReadLine
Remove-Module psreadline # Unload builtin version  
Import-Module PSReadLine -Force
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineOption -ShowToolTips
Remove-PSReadlineKeyHandler 'Ctrl+r' # This should get handled by PSFzf
Import-Module PSFzf -ArgumentList 'Alt+t', 'Ctrl+r' -Force

Import-Module -Name Get-ChildItemColor
# Set l and ls alias to use the new Get-ChildItemColor cmdlets
Set-Alias l Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope

# Import-Module -Name posh-git
# Start SshAgent if not already
# Need this if you are using github as your remote git repository
# if (! (ps | ? { $_.Name -eq 'ssh-agent' })) {
#     Start-SshAgent
# }

# Import-Module -Name oh-my-posh
# Set-Theme Paradox


Invoke-Expression (&starship init powershell)


## Azure
Enable-AzureRmAlias

#### Functions

function Invoke-Profile { 
    Write-Host "Reloading profile..."
    . $PSCommandPath 
}
Set-Alias -Name reload -Value Invoke-Profile -Force

Set-Alias fcd cde -Force
Set-Alias lg lazygit -Force
Set-Alias which get-command -Force

# Helper function to set location to the User Profile directory
function cUserProfile { Set-Location ~ }
Set-Alias -Name ~ -Value cUserProfile -Option AllScope -Force

function cUserWorkspace { Set-Location ~/source }
Set-Alias -Name src -Value cUserWorkspace -Option AllScope -Force

function Set-PathtoConfig { Set-Location $PSScriptRoot/.. }
Set-Alias -Name config -Value Set-PathtoConfig -Option AllScope -Force

function fzf-invoke { Get-ChildItem | where-object { -not $_.PSIsContainer } | Invoke-Fzf -Multi | Invoke-Item }
Set-Alias -Name fi -Value fzf-invoke -Force

# Git
function Get-GitStatus { & git status $args }
Set-Alias -Name s -Value Get-GitStatus -Force
function Set-GitCommit { & git commit -am $args }
Set-Alias -Name c -Value Set-GitCommit -Force
function Set-GitPushAll { & git push --all }
Set-Alias -Name gpa -Value Set-GitPushAll -Force

# Larger modules

Import-Module $PSScriptRoot/modules/Set-AzureFunctionState.psm1 -Force
Set-Alias -Name azfun -Value Set-AzureFunctionState -Force

Import-Module $PSScriptRoot/modules/Set-GitBranchFuzzily.psm1 -Force
Set-Alias -Name gcf -Value Set-GitBranchFuzzily -Force

Import-Module $PSScriptRoot/modules/Add-NewEmptyFile.psm1 -Force
Set-Alias -Name touch -Value Add-NewEmptyFile -Force

Import-Module $PSScriptRoot/modules/Invoke-ActionOnFuzzyTarget.psm1 -Force
Set-Alias -Name fdo -Value Invoke-ActionOnFuzzyTarget -Force

Import-Module $PSScriptRoot/modules/Invoke-AsAdministrator.psm1 -Force
Set-Alias -Name su -Value Invoke-AsAdministrator -Force

Import-Module $PSScriptRoot/modules/Ping-Endpoint.psm1 -Force
Set-Alias -Name telnet -Value Ping-Endpoint -Force

Import-Module $PSScriptRoot/modules/Run-AzPipelineFuzzily.psm1 -Force

Import-Module $PSScriptRoot/modules/Invoke-Key.psm1 -Force

Import-Module $PSScriptRoot/modules/Update-AllModules.psm1 -Force


