function Invoke-MstscFuzzily {
    param(
        $User = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name,
        [Switch] $AllScreens 
    )
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
    Write-Host "Host: " -NoNewline -ForegroundColor Yellow
    Write-Host $SelectedHost -ForegroundColor Cyan
    Write-Host "User: " -NoNewline -ForegroundColor Yellow
    Write-Host $User -ForegroundColor Cyan
    $Password = Read-Host -assecurestring "Please enter your password"
    $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
    Invoke-Expression "cmdkey /generic:$SelectedHost /user:$User /password:$Password" | Out-Null
    try {
        Start-Process -FilePath "mstsc.exe" -ArgumentList "/v:$SelectedHost /f $($AllScreens ? '/multimon' : '')"
        # $Cmd = "Invoke-Expression -Command ""mstsc /v:$SelectedHost /f $($AllScreens ? '/multimon' : '')"""
        # Start-Process -FilePath "powershell" -ArgumentList "-noprofile -nologo -command $Cmd"
    }
    finally {
        Start-Sleep -Seconds 1 
        Invoke-Expression "cmdkey /delete:$SelectedHost" | Out-Null
    }
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
    $Hosts | fzf --height 15 --header "Select the target for mstsc(rdp)" --prompt "> mstc /v:"
}

function Test-CommandExists {
    param ( [string] $Command )
    (Get-Command $Command -ErrorAction SilentlyContinue) ? $true : $false
}

Export-ModuleMember -Function Invoke-MstscFuzzily