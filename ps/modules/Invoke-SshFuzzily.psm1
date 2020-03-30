function Invoke-SshFuzzily {
    param (
        [parameter(position=0)]
        [string]
        $User = $env:UserName
    )
    ((Test-CommandExists -Command fzf) || Write-Error "Unable to find required command: fzf\nInstall using `"choco install fzf`""  -ErrorAction Stop) | Out-Null
    ((Test-CommandExists -Command ssh) || Write-Error "Unable to find required command: ssh" -ErrorAction Stop) | Out-Null

    [string[]] $AllHosts = Get-Hosts 
    if ($AllHosts.Count -eq 0) {
        Write-Error "No hosts found" -ErrorAction Stop
    }    
    [string]$SelectedHost = Select-Host -Hosts $AllHosts -User $User
    if ([string]::IsNullOrEmpty($SelectedHost)) {
        Write-Error "No host selected" -ErrorAction Stop
    }
    Write-Host "Connecting to: " -ForegroundColor Yellow -NoNewline
    Write-HOst $User@$SelectedHost -ForegroundColor Cyan
    ssh $User@$SelectedHost
}

function Get-Hosts {
    $KnownHosts = "$HOME/.ssh/known_hosts"
    Test-Path $KnownHosts | Out-Null || Write-Error "Unable to find ~/.ssh/known_hosts" -ErrorAction Stop
    Get-Content $KnownHosts | ForEach-Object { $_.Replace(",", " ").Split(" ")[0] }
}

function Select-Host {
    param (
        [string[]]
        $Hosts,
        [string]
        $User
    )
    $Hosts
    | fzf --height 10 --header "Select the target for ssh" --prompt "> ssh -l $User "
    | Foreach-Object { $_.split(" ")[0] }
}

function Test-CommandExists {
    param ( [string] $Command )
    (Get-Command $Command -ErrorAction SilentlyContinue) ? $true : $false
}

Export-ModuleMember -Function Invoke-SshFuzzily