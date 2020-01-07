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

Set-Alias lg lazygit