$NvimConfigPath = "~/.config/nvim/"

$PluggedPath = Join-Path $NvimConfigPath "plugged"
if (Test-Path $PluggedPath) {
	Write-Host "Removing $PluggedPath ..."
	Remove-Item $PluggedPath -recurse -force
}
nvim --headless +<CR> +<CR> +PlugInstall +qa

$cocInstallScript = ./plugged/coc.nvim/install.cmd
if (Test-Path $cocInstallScript) {
	& $cocInstallScript nightly
}else {
	Write-Error "Unable to find the coc install script in: $cocInstallScript"
}

$ExternalLSPBootstrap = Join-Path $NvimConfigPath lsp-install.ps1
& $ExternalLSPBootstrap 
