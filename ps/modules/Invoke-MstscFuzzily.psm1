function Invoke-MstscFuzzily {
    ((Test-CommandExists -Command fzf) || Write-Error "Unable to find required command: fzf\nInstall using `"choco install fzf`""  -ErrorAction Stop) | Out-Null
    ((Test-CommandExists -Command mstsc) || Write-Error "Unable to find required command: mstsc" -ErrorAction Stop) | Out-Null

    [string[]] $AllHosts = Get-Hosts 
    if ($AllHosts.Count -eq 0) {
        Write-Error "No hosts found" -ErrorAction Stop
    }    
    [string]$SelectedHost = Select-Host -Hosts $AllHosts
    if ([string]::IsNullOrEmpty($SelectedHost)) {
        Write-Error "No host selected" -ErrorAction Stop
    }
    Write-Host "Selected host:" $SelectedHost
    mstsc /v:$SelectedHost     
}

function Get-Hosts {
    $KnownHosts = "HKCU:\Software\Microsoft\Terminal Server Client\Default"
    Test-Path $KnownHosts | Out-Null || Write-Error "Unable to find $KnownHosts" -ErrorAction Stop
    Get-ItemProperty -Path $KnownHosts
    | Get-Member -Name "MRU*"
    | Select-Object -ExpandProperty Definition
    | Foreach-Object { $_.Split(" ")[1].Split("=")[1] }
}

function Select-Host {
    param ( [string[]] $Hosts )
    $Hosts | fzf --height 10 --header "Select the target for mstsc(rdp)" --prompt "> mstc /v:"
}

function Test-CommandExists {
    param ( [string] $Command )
    (Get-Command $Command -ErrorAction SilentlyContinue) ? $true : $false
}

Export-ModuleMember -Function Invoke-MstscFuzzily