#Requires -RunAsAdministrator 
#Requires -Version 5

function Main {
  $UserName = "flars"

<<<<<<< HEAD
<<<<<<< HEAD
  Install-Choco
  Install-Scoop
  Install-WSL
=======
  #Install-Choco
  #Install-Scoop
  #Install-WSL
>>>>>>> aa11044 (Update)
=======
  #Install-Choco
  #Install-Scoop
  #Install-WSL
>>>>>>> aa11044 (Update)
  Install-SSH -UserName $UserName
  Install-DockerDesktop
  Install-Ansible
} 

function Install-DockerDesktop {
  Install-WithChoco docker-desktop
  if (-not (Test-Path "$env:ProgramFiles/docker/docker/dockercli.exe")) {
    throw "Unable to find docker desktop cli"
  }
  { & "$env:ProgramFiles/docker/docker/dockercli.exe -SwitchLinuxEngine" },
  { & "docker build -f $PSScriptRoot/Dockerfile.alpine . -t ansible" },
  { & "docker run ansible" } | Invoke-Native 
}

function Install-Ansible {
  New-NetFirewallRule -DisplayName "Allow SSH to WSL host" -Protocol TCP -Direction Inbound -LocalPort 2222 -Action Allow
  # "sudo apt-get -y install python-pip python-dev libffi-dev libssl-dev",
  # "pip install ansible --user",
  # "echo 'PATH=$HOME/.local/bin:`$PATH' >> ~/.bashrc",
  # "which ansible" | Invoke-Bash
}

function Invoke-Bash {
  param (
    [parameter(ValueFromPipeline, Position = 0)]
    [string]$Command
  )
  Process {
    Invoke-Native { bash.exe -c $Command }
  }
}

function Install-WithScoop {
  param (
    [parameter(ValueFromPipeline, Position = 0)]
    [string] $Package
  )

  Process {
    Write-Host "Installing $Package"
    scoop install $Package
  }
}

function Install-WithChoco {
  param (
    [parameter(ValueFromPipeline, Position = 0)]
    [string] $Package,
    [string] $Params = "",
    [string] $ExtraArgs = ""
  )

  Process {
    if (Test-ChocolateyPackageInstalled -Package $Package) {
      Write-Host "Found package $Package already installed, skipping"
    }
    else {
      Write-Host "Installing $Package"
      Invoke-Native { choco.exe install $Package --params "$params" --yes --limit-output $ExtraArgs }
    }
  }
}

function Test-ChocolateyPackageInstalled {
  Param (
    [ValidateNotNullOrEmpty()]
    [string]
    $Package
  )

  Process {
    if (Test-Path -Path $env:ChocolateyInstall) {
      $packageInstalled = Test-Path -Path $env:ChocolateyInstall\lib\$Package
    }
    else {
      throw "Can't find a chocolatey install directory..."
    }

    return $packageInstalled
  }
}

function Install-Scoop {
  Set-ExecutionPolicy Bypass -Scope Process -Force; 
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 

  Write-Host "Downloading and installing scoop"
  Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}

function Install-Choco {
  Set-ExecutionPolicy Bypass -Scope Process -Force; 
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 

  Write-Host "Downloading and installing chocolatey"
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

function Install-SSH {
  param (
    $UserName
  )
  Write-Host "Installing openssh"
  Install-WithChoco openssh -Params '"/SSHServerFeature"'

  $SshKeyLoc = "$env:USERPROFILE/.ssh/id_ed25519"
  if (-not (Test-Path $SshKeyLoc)) {
    Write-Host "Generating ssh key: $SshKeyLoc"
    & ssh-keygen -q -f $SshKeyLoc -t ed25519 -P """"
  }
  else {
    Write-Host "$SshKeyLoc key exists, skipping generation"
  }
  $SshKey = Get-Content "$SshKeyLoc.pub"

  $AdminKeyFile = "$Env:ProgramData/ssh/administrators_authorized_keys"
  $UserKeyFile = "$Env:USERPROFILE/.ssh/authorized_keys"
  $AdminKeyFile, $UserKeyFile | Add-KeyIfNotExists -Key $SshKey 

  Write-Host "Setting admin authorized keys ACL"
  $Acl = Get-Acl $AdminKeyFile 
  $Acl.SetAccessRuleProtection($true, $false)
  $AdministratorsRule = New-Object System.Security.Accesscontrol.FileSystemAccessRule("Administrators", "FullControl", "Allow")
  $SystemRule = New-Object System.Security.Accesscontrol.FileSystemAccessRule("SYSTEM", "FullControl", "Allow")
  $Acl.SetAccessRule($AdministratorsRule)
  $Acl.SetAccessRule($SystemRule)
  $Acl | Set-Acl

<<<<<<< HEAD
<<<<<<< HEAD
  "mkdir -p ~/.ssh/ 
  && cat /mnt/c/Users/flars/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys 
  && chmod 700 ~/.ssh 
  && chmod 600 ~/.ssh/authorized_keys" | Invoke-Bash 

  "cp /mnt/c/Users/$UserName/.ssh/id_ed25519 ~/.ssh/" 
  "chmod 0600 ~/.ssh/id_ed25519" | Invoke-Bash 
=======
  "mkdir -p ~/.ssh/ && cat /mnt/c/Users/flars/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys && chmod 700 ~/.ssh && cp /mnt/c/Users/$UserName/.ssh/id_ed25519 ~/.ssh/ && chmod 0600 ~/.ssh/id_ed25519" | Invoke-Bash 
>>>>>>> aa11044 (Update)
=======
  "mkdir -p ~/.ssh/ && cat /mnt/c/Users/flars/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys && chmod 700 ~/.ssh && cp /mnt/c/Users/$UserName/.ssh/id_ed25519 ~/.ssh/ && chmod 0600 ~/.ssh/id_ed25519" | Invoke-Bash 
>>>>>>> aa11044 (Update)
}

function Add-KeyIfNotExists {
  param(
    [parameter(ValueFromPipeline)]$File,
    $Key
  )
  PROCESS { 
    
    $FileContent = if (Test-Path $File) { Get-Content $File } else { "" }
    if (-not ($Key -in $FileContent)) {
      Write-Host "Adding key to $File"
      $Key >> $File
    }
    else {
      Write-Host "Found key in $File, skipping"
    }
  }
}

function Install-WSL {
  if (-not (Test-ChocolateyPackageInstalled -Package wsl2)) {
    Install-WithChoco wsl2 -Params "/Version:2 /Retry:true"
    $RunOnceKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
    Set-ItemProperty $RunOnceKey "NextRun" "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted -File $PSCommandPath"
    Write-Host "This script requires a reboot after installing WSL2, the script will autorun after the reboot is complete"

    $EndTime = [datetime]::UtcNow.AddSeconds(10)
    while (($TimeRemaining = ($EndTime - [datetime]::UtcNow)) -gt 0) {
      Write-Progress -Activity 'Bootstrapping system' -Status "Rebooting after WSL install" -SecondsRemaining $TimeRemaining.TotalSeconds
      Start-Sleep 1
    }
    # Restart-Computer
    exit 0
  }


  # $WSL = "Microsoft-Windows-Subsystem-Linux" 
  # $VMP = "VirtualMachinePlatform"
  # $FeatureChanged = $WSL, $VMP | Enable-Feature 

  # if ($FeatureChanged) {
  #   Write-Host "At least one feature enabled. Restart requires.`nRun this script again after reboot"
  #   exit 0
  # }
  Install-WithScoop archwsl

  $WSLUpdate = "$Env:TEMP\wsl_update.msi"
  if (-not (Test-Path $WSLUpdate)) {
    Write-Host "Downloading WSL kernel update"
    $Uri = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
    (New-Object -TypeName System.Net.WebClient).DownloadFile($Uri, $WSLUpdate)
  }
  else {
    Write-Verbose "Kernel update already exists, using existing: $WSLUpdate"
  }

  Write-Host "Installing WSL kernel update"
  Start-Process msiexec.exe -Wait -ArgumentList "/i $WSLUpdate /quiet" -NoNewWindow

  Write-Host "Setting default version to WSL2"
  wsl --set-default-version 2
}

# Wrapper for native command execution
#   Powershell/CMD is insane when it comes to native execution 
function script:Invoke-Native {
  [cmdletbinding()]
  param (
    [parameter(ValueFromPipeline)]
    [ScriptBlock] $ScriptBlock,
    [switch]$Quiet = $false
  )
  BEGIN {
    $backupErrorActionPreference = $ErrorActionPreference
 
    $ErrorActionPreference = "Continue"
    try {
      & $ScriptBlock 2>&1 | ForEach-Object -Process `
      {
        if ($Quiet) {
          return;
        }

        if (($DebugPreference -eq 'Continue') -and ($_ -is [System.Management.Automation.ErrorRecord])) {
          "stdErr: $_"
        }
        else {
          "$_"
        }
      }
      if (0 -ne $LASTEXITCODE) {
        throw "Execution failed with exit code $LASTEXITCODE"
      }
    }
    finally {
      $ErrorActionPreference = $backupErrorActionPreference
    }
  }
}

Main