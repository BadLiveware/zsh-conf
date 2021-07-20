#!/usr/bin/env sh

dnses=$(powershell.exe -noprofile -command '
Get-DnsClientServerAddress -AddressFamily ipv4 `
| Select-Object -ExpandProperty ServerAddresses `
| Get-Unique `
| ForEach-Object { $a="" } `
                 { $a+="$_ " } `
                 { $a.trimend(" ") }')

echo "Please enter your password if requested."

for dns in $dnses
do 
    echo "$dns"
    dns_entry="nameserver ${dns}"
    matches_in_hosts=$(grep -n "$dns_entry" /etc/resolv.conf)


    if [ -z "$matches_in_hosts" ]
    then
        echo "Adding new nameserver entry."
        echo "$dns_entry" | sudo tee -a /etc/resolv.conf > /dev/null
        sudo sed -i -e "s/\r//g" /etc/resolv.conf
    fi
done