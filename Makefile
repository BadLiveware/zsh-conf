mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

init:
	@echo "--- Initializing repo ---"
	git submodule update --init
	@echo ""

install: init
	@echo "--- Installing zsh ---"
	echo "source $(mkfile_dir)/zshrc.zsh" > "$$HOME/.zshrc"
	echo ". $(mkfile_dir)/zshenv.zsh" > "$$HOME/.zshenv"
	echo "source $(mkfile_dir)/zprofile.zsh" > "$$HOME/.zprofile"
