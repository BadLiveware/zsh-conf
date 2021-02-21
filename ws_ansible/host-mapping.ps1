function Get-NetAddr { 
  param (
    $AdapterName
  )
  $Adapter = Get-NetAdapter -Name $Adapter -IncludeHidden
  $Ip = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $Adapter.ifIndex
  select -ExpandProperty IPAddress -InputObject () 
}

$WindowsIP = Select-Object -ExpandProperty IPAddress -InputObject (Get-NetAdapter -Name "Wi-Fi" -IncludeHidden | Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex 4) 
$WslIp = Select-Object -ExpandProperty IPAddress -InputObject (Get-NetAdapter -Name "vEthernet (WSL)" -IncludeHidden | Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex 4) 
