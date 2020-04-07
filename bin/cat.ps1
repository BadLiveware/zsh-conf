Get-Command bat.exe -ErrorAction SilentlyContinue || Tee-Object -Variable UseBat && Write-Error "Unable to find bat executable, defaulting to get-content" -ErrorAction SilentlyContinue

if ($UseBat) {
    bat $args[0]
} else { 
    cat $args[0] 
}