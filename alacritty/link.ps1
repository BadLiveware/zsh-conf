$Source = Resolve-Path "$PSScriptRoot/alacritty.yml"
$Target = Resolve-Path "$Env:AppData/alacritty/alacritty.yml"
Write-Host @"
Linking
  $Source -> $Target
"@

New-Item -ItemType HardLink "$Target" -Value "$Source" -Force