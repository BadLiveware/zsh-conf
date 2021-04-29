[cmdletbinding()]
param (
    $BecomePassword = ""
    
)
$IsDebug = $PSCmdlet.MyInvocation.BoundParameters["Debug"].IsPresent

<<<<<<< HEAD
<<<<<<< HEAD
$WslIp = wsl hostname -I
=======
$WslIp = wsl hostname -i
>>>>>>> aa11044 (Update)
=======
$WslIp = wsl hostname -i
>>>>>>> aa11044 (Update)
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
    Write-Host "Building image"
    $ImageSha = (docker build -q -f .\Dockerfile .) -replace "sha256:"

    Write-Host "Starting container..."
    $Arguments = 
        "run",
        "--rm",
        "--net host",
        "--mount type=bind,source=$SshConfigTmp,target=/root/.ssh/config",
        "--mount type=bind,source=$(Resolve-Path $Env:HOMEPATH)/.ssh/id_ecdsa,target=/root/.ssh/id_ecdsa",
        "$(if($IsDebug) { `"-e 'DEBUG=true'`" })",
        "$ImageSha"
    $DockerExe = get-command docker | Select-Object -ExpandProperty Source
<<<<<<< HEAD
<<<<<<< HEAD
    $Command = "$DockerExe run $Arguments"
=======
    $Command = "$DockerExe $Arguments"
>>>>>>> aa11044 (Update)
=======
    $Command = "$DockerExe $Arguments"
>>>>>>> aa11044 (Update)
    Write-Host "`nRunning command: $Command" -ForegroundColor Cyan

    Start-Process -FilePath $DockerExe -ArgumentList $Arguments -Wait -NoNewWindow -Verbose:$IsDebug
}
finally {
    Write-Host "Cleaning up generated ssh config"
    Remove-Item -Recurse -Force $SshConfigTmp
}