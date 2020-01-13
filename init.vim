" General
language en_gb
set spell spelllang=en_gb
set relativenumber
set shell=pwsh.exe
set shellcmdflag=-noprofile\ -Nologo\ -noninteractive\ -command
set shellpipe=|
set shellredir=>

" Windows clipboard
source $VIMRUNTIME/mswin.vim

"Deoplete settings
let g:deoplete#enable_at_startup = 1
let g:python3_host_prog = 'C:\Python38\python.exe'
set completeopt-=preview

" Plugins
call plug#begin('~/AppData/Local/nvim/plugged')
Plug 'tpope/vim-sensible'
Plug 'PProvost/vim-ps1'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
call plug#end()

" Theme
:colorscheme onedark

