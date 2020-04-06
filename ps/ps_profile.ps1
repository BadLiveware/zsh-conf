function Load-Profile {
  Write-Host "Starting loading profile..." -ForegroundColor Yellow

  # Doesnt work because of runspaces or scopes idk
  # "Import-PSReadLine",
  # "Import-BaseModules",
  # "Import-Prompt",
  # "Import-InlineFunctions",
  # "Import-CustomModules"
  # | Foreach-Object -Parallel global:{ Write-Host "Invoking: $_";. $_ }

  . Import-PSReadLine
  . Import-BaseModules
  . Import-Prompt 
  . Import-InlineFunctions
  . Import-CustomModules
  . Setup-Autocomplete

  ## Azure
  Enable-AzureRmAlias

  Write-Host "Finished loading profile..." -ForegroundColor Yellow
}

function Import-PSReadLine {
  Write-Host "Loading PSReadLine options..." -ForegroundColor Cyan
  # PSReadLine
  Remove-Module psreadline # Unload builtin version  
  Import-Module PSReadLine -Force
  Set-PSReadlineKeyHandler -Key Tab -Function Complete
  Set-PSReadlineOption -ShowToolTips
  Remove-PSReadlineKeyHandler 'Ctrl+r' # This should get handled by PSFzf
}

function Import-BaseModules {
  Write-Host "Importing base modules options..." -ForegroundColor Cyan
  Import-Module PSFzf -ArgumentList 'Alt+t', 'Ctrl+r' -Force


  Import-Module -Name Get-ChildItemColor
  # Set l and ls alias to use the new Get-ChildItemColor cmdlets
  Set-Alias l Get-ChildItemColor -Option AllScope
  Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope
}

function Import-Prompt {
  Write-Host "Starting prompt..." -ForegroundColor Cyan
  Invoke-Expression (&starship init powershell)
}

function Import-InlineFunctions {
  Write-Host "Loading custom functions..." -ForegroundColor Cyan
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
  Set-Alias -Name ~ -Value cUserProfile -Force -Option AllScope

  function cUserWorkspace { Set-Location ~/source }
  Set-Alias -Name src -Value cUserWorkspace -Force -Option AllScope

  function Set-PathToConfig { Set-Location $PSScriptRoot/.. }
  Set-Alias -Name config -Value Set-PathToConfig -Force -Option AllScope

  function fzf-invoke { Get-ChildItem | where-object { -not $_.PSIsContainer } | Invoke-Fzf -Multi | Invoke-Item }
  Set-Alias -Name fi -Value fzf-invoke -Force  

  # Git
  function Get-GitStatus { & git status $args }
  Set-Alias -Name s -Value Get-GitStatus -Force  
  function Set-GitCommit { & git commit -am $args }
  Set-Alias -Name c -Value Set-GitCommit -Force  
  function Set-GitPushAll { & git push --all }
  Set-Alias -Name gpa -Value Set-GitPushAll -Force  
}

function Import-CustomModule {
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]
    $FileName,
    [string]
    $Extension = ".psm1",
    [Parameter(Mandatory = $false, ParameterSetName = "Alias", Position = 1)]
    [string]
    $Alias,
    [Parameter(Mandatory = $false, ParameterSetName = "Alias")]
    [string]
    $AliasValue = $FileName,
    [switch]
    $NotForce
  )
  $ModuleDir = "$PSScriptRoot/modules/"
  $File = $FileName + $Extension
  if (Join-Path $ModuleDir $File | Tee-Object -Variable Module | Test-Path) {
    Import-Module $Module -Force:(-not $NotForce) 

    if ($PSBoundParameters.ContainsKey("Alias")) {
      Set-Alias -Name $Alias -Value $AliasValue -Force:$Force -Scope global
    }
  }
  else {
    Write-Error "Unable to find module file: $Module"
  }
}

function Import-CustomModules {
  Write-Host "Loading custom modules" -ForegroundColor Cyan

  Import-CustomModule Set-AzureFunctionState azfun
  Import-CustomModule Ping-Endpoint telnet
  Import-CustomModule Set-GitBranchFuzzily gcf
  Import-CustomModule Add-NewEmptyFile touch 
  Import-CustomModule Invoke-ActionOnFuzzyTarget fdo 
  # Import-CustomModule Invoke-AsAdministrator su 
  Import-CustomModule Invoke-SshFuzzily sshf
  Import-CustomModule Invoke-MstscFuzzily rdpf
  Import-CustomModule Run-AzPipelineFuzzily 
  Import-CustomModule Invoke-Key 
  Import-CustomModule Update-AllModules 
}

function Setup-Autocomplete {
  # PowerShell parameter completion shim for the dotnet CLI
  Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
      [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
  }
}

. Load-Profile
