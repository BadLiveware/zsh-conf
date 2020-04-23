param (
    [parameter(mandatory=$true, position=0)]
    $File
)

((get-command bat.exe 2>&1 | out-null) && & bat.exe --color=always $File) || get-content $File