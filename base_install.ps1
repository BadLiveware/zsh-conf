#Requires -RunAsAdministrator

Write-Host "Installing basic shell components" -ForegroundColor Yellow
& choco install powershell-core starship lf fzf ripgrep curl bat --yes --limit-output
& choco install gsudo --prerelease --yes --limit-output

Write-Host "Installing user components" -ForegroundColor Yellow
& choco install firefox 7zip keepass vlc firacode slack discord everything autohotkey powertoys --yes --limit-output

Write-Host "Installing development components" -ForegroundColor Yellow
& choco install python3 python2 dotnetcore dotnetfx git procmon procexp --yes --limit-output

Write-Host "Installing editors and IDEs components" -ForegroundColor Yellow
& choco install neovim visualstudio vscode winmerge notepadplusplus --yes --limit-output

Write-Host "Installing python components" -ForegroundColor Green
& python -m pip install --upgrade pip
& pip install glances

Write-Host "Installing powershell modules"
$PowershellModules = "PSEverything", "PSFzf"; # PSReadLine is built-in for powershell-core 6
$PowershellModules | ForEach-Object { & pwsh.exe -NonInteractive -NoProfile -NoLogo -Command Install-Module -Name $_ -AllowPrerelease }
