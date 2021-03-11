#!/usr/bin/env sh

ip_address="$(powershell.exe -noprofile -command '
Get-NetAdapter -Physical -Name "Ethernet*" `
| Select-Object -ExpandProperty ifIndex `
| Get-Unique `
| ForEach-Object { Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $_ } `
| Select-Object -expandproperty ipaddress `
| select-object -first 1 `
| % { "$_" }
')"
echo "Found ip: $ip_address"

host_name="windows.local"

# find existing instances in the host file and save the line numbers
host_entry="${ip_address} ${host_name}"
matches_in_hosts=$(grep -n "${host_entry}" /etc/hosts)

echo "Please enter your password if requested."

if [ -z "$matches_in_hosts" ]
then
    echo "Adding new hosts entry."
    echo "${host_entry}" | sudo tee -a /etc/hosts > /dev/null 
    sudo sed -i -e "s/\r//g" /etc/hosts
fi:wa
