#Requires -RunAsAdministrator

Write-Host "Installing basic shell components" -ForegroundColor Yellow
& choco install powershell-core starship lf fzf ripgrep curl --yes --limit-output

Write-Host "Installing user components" -ForegroundColor Yellow
& choco install firefox 7zip keepass vlc firacode slack discord everything autohotkey --yes --limit-output

Write-Host "Installing development components" -ForegroundColor Yellow
& choco install python3 python2 dotnetcore dotnetfx git  --yes --limit-output

Write-Host "Installing editors and IDEs components" -ForegroundColor Yellow
& choco install neovim visualstudio vscode winmerge notepadplusplus.install --yes --limit-output

trite-Host "Installing python components" -ForegroundColor Green
python -m pip install --upgrade pip
& pip install glances

Write-Host "Installing powershell modules"
$PowershellModules = "PSReadLine", "PSEverything", "oh-my-posh", "posh-git", "PSFzf";
$PowershellModules | ForEach-Object { & pwsh.exe -NonInteractive -NoProfile -NoLogo -Command Install-Module -Name $_ -AllowPrerelease }
