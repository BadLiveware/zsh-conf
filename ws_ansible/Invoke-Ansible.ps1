$WslIp = wsl hostname -I
Write-Host "Found WSL ip: $WslIp"

$seed = [guid]::newguid().tostring()
$SshConfigTmp = "$Env:TEMP/$Seed/.ssh/config"
New-Item -ItemType File -Path $SshConfigTmp -Force -Value @"
# Generated file, do not edit

Host *
StrictHostKeyChecking no

Host windows
        HostName host.docker.internal
        User $Env:USERNAME
        IdentityFile /root/.ssh/id_ecdsa
        Port 22

Host wsl
        HostName $WslIp
        ProxyJump windows
        User dev
        IdentityFile /root/.ssh/id_ecdsa
        Port 2222

"@ | Out-Null
Write-Host "Created temporary ssh config: $SshConfigTmp"
Get-Content $SshConfigTmp | ForEach-Object { Write-Verbose "`t$_" }

try {
    Write-Host "Starting container...`n"
    $DockerId = docker run `
        --rm `
        --net host `
        --mount type=bind,source="$SshConfigTmp",target="/root/.ssh/config" `
        --mount type=bind,source="$(Resolve-Path $Env:HOMEPATH)/.ssh/id_ecdsa",target="/root/.ssh/id_ecdsa" `
        $(docker build -q -f .\Dockerfile .)
}
finally {
    Write-Host "Cleaning up generated ssh config"
    Remove-Item -Recurse -Force $SshConfigTmp
}
$DockerId