# PSReadLine
Remove-Module psreadline # Unload builtin version  
Import-Module PSReadLine
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineOption -ShowToolTips
Remove-PSReadlineKeyHandler 'Ctrl+r' # This should get handled by PSFzf
Import-Module PSFzf -ArgumentList 'Alt+t', 'Ctrl+r'

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
Set-Alias -Name reload -Value Invoke-Profile

function Add-NewEmptyFile {
    param ([parameter(Position = 0)][string] $Filename)
    New-Item -ItemType file $Filename
}
Set-Alias -Name touch -Value Add-NewEmptyFile;

# Helper function to set location to the User Profile directory
function cUserProfile { Set-Location ~ }
Set-Alias ~ cUserProfile -Option AllScope

function cUserWorkspace { Set-Location ~/source }
Set-Alias cws cUserWorkspace -Option AllScope

Set-Alias fcd cde
Set-Alias lg lazygit
Set-Alias which get-command

function Get-GitStatus { & git status $args }
Set-Alias -Name s -Value Get-GitStatus
function Set-GitCommit { & git commit -am $args }
Set-Alias -Name c -Value Set-GitCommit 
function Set-GitPushAll { & git push --all }
Set-Alias -Name gpa -Value Set-GitPushAll

function fzf-invoke { Get-ChildItem | where-object { -not $_.PSIsContainer } | Invoke-Fzf -Multi | Invoke-Item }
Set-Alias fdo fzf-invoke

Import-Module $PSScriptRoot/modules/Set-AzureFunctionState.psm1 -Force
Set-Alias azfun Set-AzureFunctionState

Import-Module $PSScriptRoot/modules/Set-GitBranchFuzzily.psm1 -Force
Set-Alias -Name gcf -Value Set-GitBranchFuzzily
