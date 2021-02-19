$Source = Resolve-Path "$PSScriptRoot/../settings.json"
$Target = Resolve-Path "$Env:LOCALAPPDATA/Microsoft/Windows Terminal/settings.json"
Write-Host @"
Linking
  $Source -> $Target
"@

New-Item -ItemType HardLink "$Target" -Value "$Source" -Force