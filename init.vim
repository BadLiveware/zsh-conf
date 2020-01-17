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

let mapleader ="\<Space>"

" Plugins
call plug#begin('~/AppData/Local/nvim/plugged')
Plug 'tpope/vim-sensible'
Plug 'PProvost/vim-ps1'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ripxorip/aerojump.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'joshdick/onedark.vim'
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
call plug#end()

"Deoplete settings
let g:deoplete#enable_at_startup = 1
let g:python3_host_prog = 'C:\Python38\python.exe'
set completeopt-=preview

" Aerojump
nmap <Leader>as <Plug>(AerojumpSpace)
nmap <Leader>ab <Plug>(AerojumpBolt)
nmap <Leader>aa <Plug>(AerojumpFromCursorBolt)
nmap <Leader>ad <Plug>(AerojumpDefault) " Boring mode

" Theme
colorscheme challenger_deep
if has('nvim') || has('termguicolors')
  set termguicolors
endif
let g:lightline = { 'colorscheme': 'challenger_deep'}

