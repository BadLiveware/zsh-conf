function Load-Profile {
  $Env:PSModulePath = (($Env:PSModulePath -split ";") | ? { $_ -notlike "\\Storage01-a\*" }) -join ";" 
  Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

  . Echo-Load { . Import-PSReadLine } "PSReadLine options"

  . Echo-Load { . Import-BaseModules } "base modules options"
  . Echo-Load { . Import-Prompt } "prompt"
  . Echo-Load { . Import-InlineFunctions } "custom functions"
  . Echo-Load { . Import-CustomModules } "custom modules"
  . Echo-Load { . Setup-Autocomplete } "auto complete"

  ## Azure
  # Enable-AzureRmAlias
}

function Echo-Load {
  param(
    $Function,
    $FriendlyName
  )
  $Timer = [system.diagnostics.stopwatch]::StartNew()
  Write-Host "Loading $FriendlyName..." -ForegroundColor Cyan -NoNewline
  . $Function
  Write-Host " [$([int]$Timer.Elapsed.TotalMilliseconds)ms]" -ForegroundColor DarkCyan
  $Timer.Stop()
}

function Ensure-Module {
  param ( 
    [string] $ModuleName,
    [switch] $AllowPrerelease,
    [string[]] $ImportArgumentList,
    [switch] $AllowClobber
  )
  if (-not ((Get-InstalledModule -Name $ModuleName -AllowPrerelease:$AllowPrerelease -ErrorAction SilentlyContinue) ?? $false)) {
    Write-Host "`n  Unable to find $ModuleName, installing..."
    Install-Module -Name $ModuleName -AllowPrerelease:$AllowPrerelease -AllowClobber:$AllowClobber
  }
  Import-Module $ModuleName -ArgumentList $ImportArgumentList -Force
}

function Import-PSReadLine {
  # PSReadLine
  Remove-Module psreadline # Unload builtin version  
  Ensure-Module "PSReadLine" -AllowPrerelease
  Set-PSReadlineKeyHandler -Key Tab -Function Complete
  Set-PSReadlineOption -ShowToolTips -MaximumHistoryCount 1000 -HistoryNoDuplicates
  Remove-PSReadlineKeyHandler 'Ctrl+r' # This should get handled by PSFzf
}

function Import-BaseModules {
  Ensure-Module "PSFzf" -ImportArgumentList 'Alt+t', 'Ctrl+r'
  Set-PsFzfOption -TabExpansion

  Ensure-Module "Get-ChildItemColor" -AllowClobber
  # Set l and ls alias to use the new Get-ChildItemColor cmdlets
  Set-Alias l Get-ChildItemColor -Option AllScope
  Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope
}

function Import-Prompt {
  Invoke-Expression (& starship init powershell)
}

function Import-InlineFunctions {
  function Invoke-Profile { 
    Write-Host "Reloading profile..."
    . $PSCommandPath 
  }
  Set-Alias -Name reload -Value Invoke-Profile -Force  

  Set-Alias j cde -Force
  Set-Alias jmp cde -Force  
  Set-Alias jump cde -Force  

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
    $Timer = [system.diagnostics.stopwatch]::StartNew()
    Import-Module $Module -Force:(-not $NotForce)
    Write-Host "`n  $File" -ForegroundColor Magenta -NoNewline
    Write-Host " [$([int]$Timer.Elapsed.TotalMilliseconds)ms]" -ForegroundColor Green -NoNewline
    $Timer.Stop()

    if ($PSBoundParameters.ContainsKey("Alias")) {
      Set-Alias -Name $Alias -Value $AliasValue -Force:$Force -Scope global
    }
  }
  else {
    Write-Error "Unable to find module file: $Module"
  }
}

function Import-CustomModules {
  Import-CustomModule Set-AzureFunctionState azfun
  Import-CustomModule Ping-Endpoint telnet
  Import-CustomModule Set-GitBranchFuzzily gcf
  Import-CustomModule Add-NewEmptyFile touch 
  Import-CustomModule Invoke-ActionOnFuzzyTarget fdo 
  Import-CustomModule Invoke-SshFuzzily sshf
  Import-CustomModule Invoke-MstscFuzzily rdpf
  Import-CustomModule Run-AzPipelineFuzzily 
  Import-CustomModule Invoke-Key 
  Import-CustomModule Update-AllModules 
  Import-CustomModule Git-Fzf
  Write-Host ""
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
$OriginalPref = $ProgressPreference # Default is 'Continue'
$ProgressPreference = "SilentlyContinue"

$Timer = [system.diagnostics.stopwatch]::StartNew()
Write-Host "Starting loading profile..." -ForegroundColor Yellow
. Load-Profile
Write-Host "Finished loading profile" -NoNewline -ForegroundColor Yellow 
Write-Host " [$([int  ]$Timer.Elapsed.TotalMilliseconds)ms]" -ForegroundColor green
$Timer.Stop()

$ProgressPreference = $OriginalPref
