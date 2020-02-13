Write-Host "Installing basic shell components" -ForegroundColor Yellow
& choco install powershell-core lf fzf ripgrep curl -y

Write-Host "Installing user components" -ForegroundColor Yellow
& choco install firefox 7zip keepass2 vlc firacode slack discord everything autohotkey -y 

Write-Host "Installing development components" -ForegroundColor Yellow
& choco install python3 python2 dotnetcore dotnetfx git  -y 

Write-Host "Installing editors and IDEs components" -ForegroundColor Yellow
& choco install neovim visualstudio vscode winmerge notepadplusplus.install -y 

Write-Host "Installing python components" -ForegroundColor Green
& pip install glances

Write-Host "Installing powershell modules"
& pwsh.exe -NonInteractive -NoProfile -NoLogo -Command Install-Module PSReadLine PSEverything oh-my-posh posh-git PSFzf -AllowPrerelease