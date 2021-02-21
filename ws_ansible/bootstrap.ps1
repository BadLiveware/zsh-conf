#Requires -RunAsAdministrator
[cmdletbinding()]
param(
  [string]$User = $env:username, 
  [string]$Password)

  if ($Password -eq "") {
    $Credential = Get-Credential -UserName $User
  }
  else {
    $SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential ($User, $SecurePassword)
  }
Write-Host "Setting up user: $User"

function Main {
  . Install-WinRM
  . Install-WinRMAuth -Credential $Credential
  . Install-WSL
} 

function Enable-Feature {
  param ([parameter(ValueFromPipeline)]$Feature)
  if ((Get-WindowsOptionalFeature -FeatureName $Feature -Online).State -ne "Enabled") {
    Write-Host "Enabling feature: $Feature"
    Enable-WindowsOptionalFeature -FeatureName $Feature -Online -NoRestart
    return $True
  }
  Write-Verbose "Feature $Feature is already enabled, skipping"
  return $False
}

function Install-WSL {
  $WSL = "Microsoft-Windows-Subsystem-Linux" 
  $VMP = "VirtualMachinePlatform"
  $FeatureChanged = $WSL, $VMP | Enable-Feature 

  if ($FeatureChanged) {
    Write-Host "At least one feature enabled. Restart requires.`nRun this script again after reboot"
    exit 0
  }

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

function Check-WinRM {
  $Listeners = winrm enumerate winrm/config/Listener

  # Strip empty lines
  $Listeners = $Listeners | Where-Object { $_ -ne "" }
  # Find any output matching "Port = 5985.*Enabled = true"
  $ListenerOn = ($Listeners -join ";" -split "Listener;") | ForEach-Object { $any = $false } { $any = $any -or ($_ -match "Port = 5985.*Enabled = true") } { $any }
  return $ListenerOn
}

function Install-WinRMAuth {
  param  (
    [PSCredential]$Credential
  )

  # Set the name of the local user that will have the key mapped
  $Username = $Credential.UserName 
  $Output_path = "$Env:TEMP/certs"
  if (-not (Test-Path $Output_path)) {
    New-Item -Path $Output_path -ItemType Directory | out-null
  }

  # Instead of generating a file, the cert will be added to the personal
  # LocalComputer folder in the certificate store
  $CertOpts = @{
    Type          = "Custom"
    Subject       = "CN=$Username"
    TextExtension = @("2.5.29.37={text}1.3.6.1.5.5.7.3.2", "2.5.29.17={text}upn=$username@localhost")
    KeyUsage      = "DigitalSignature", "KeyEncipherment"
    KeyAlgorithm  = "RSA" 
    KeyLength     = 2048
  }
  $cert = New-SelfSignedCertificate @CertOpts
  # Export the public key
  $pem_output = @()
  $pem_output += "-----BEGIN CERTIFICATE-----"
  $pem_output += [System.Convert]::ToBase64String($cert.RawData) -replace ".{64}", "$&`n"
  $pem_output += "-----END CERTIFICATE-----"
  [System.IO.File]::WriteAllLines("$Output_path\cert.pem", $pem_output)
  # Export the private key in a PFX file
  [System.IO.File]::WriteAllBytes("$Output_path\cert.pfx", $cert.Export("Pfx"))

  $cert = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList $("$Output_path/cert.pem")
  $CertThumbprint = $cert.Thumbprint

  $store_name = [System.Security.Cryptography.X509Certificates.StoreName]::Root
  $store_location = [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine
  $store = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Store -ArgumentList $store_name, $store_location
  $store.Open("MaxAllowed")
  $store.Add($cert)
  $store.Close()

  Write-Host "Created certificate with thumbprint: $CertThumbprint"

  # This is the issuer thumbprint which in the case of a self generated cert
  # is the public key thumbprint, additional logic may be required for other
  # scenarios
  # $thumbprint = (Get-ChildItem -Path cert:\LocalMachine\root | Where-Object { $_.Subject -eq "CN=$username" }).Thumbprint
  $ClientCertOpts = @{
    Path       = "WSMan:\localhost\ClientCertificate"
    Subject    = "$username@localhost"
    URI        = "*"
    Issuer     = $CertThumbprint
    Credential = $Credential
    Force      = $true
  }
  New-Item @ClientCertOpts
}

function Install-WinRM {
  if (Check-WinRM) {
    Write-Host "WinRM is already setup"
    return
  }

  $Uri = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
  $File = "$env:temp\ConfigureRemotingForAnsible.ps1"
  if (-not (Test-Path $File)) {
    Write-Host "Downloading WinRM setup script"
    (New-Object -TypeName System.Net.WebClient).DownloadFile($Uri, $File)
  }
  else {
    Write-Verbose "WinRM setup script already exists, using existing: $File"
  }

  Write-Host "Running WinRM setup script"
  Start-Process powershell.exe -Wait -ArgumentList "$File" -NoNewWindow

  if (-not (Check-WinRM)) {
    Write-Error "WinRM setup failed"
    return
  }

  Write-Host "WinRM setup complete"
}

. Main