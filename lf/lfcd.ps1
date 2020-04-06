# Change working dir in powershell to last dir in lf on exit.
#
# You need to put this file to a folder in $ENV:PATH variable.

$tmp = [System.IO.Path]::GetTempFileName()
lf -last-dir-path="$tmp" $args
if (Test-Path -pathtype leaf "$tmp") {
    $dir = Get-Content "$tmp"
    Remove-Item -force "$tmp"
    if (Test-Path -pathtype container "$dir") {
        if ("$dir" -ne "$pwd") {
            Set-Location "$dir"
        }
    }
}
