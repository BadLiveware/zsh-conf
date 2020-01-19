call plug#begin('~/.config/nvim/plugged')
" Aesthetics
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
Plug 'itchyny/lightline.vim'
Plug 'junegunn/rainbow_parentheses.vim'

" Base functionality
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sensible'
Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim', { 'branch': 'release'}
" Plug 'neoclide/coc.nvim', { 'do': 'yarn install --frozen-lockfile'}

" Program specific
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Language specific
Plug 'PProvost/vim-ps1'

" Plug 'iamcco/coc-vimlsp', { 'do': 'yarn install --frozen-lockfile' }
" Plug 'neoclide/coc-json', { 'do': 'yarn install --frozen-lockfile' }
" Plug 'neoclide/coc-yaml', { 'do': 'yarn install --frozen-lockfile' }
" Plug 'coc-extensions/coc-powershell', { 'do': 'yarn install --frozen-lockfile' }
" Plug 'coc-extensions/coc-omnisharp', { 'do': 'yarn install --frozen-lockfile' }

call plug#end()

" General
language en_gb
set spell spelllang=en_gb

" Windows specifics 
source $VIMRUNTIME/mswin.vim
set keymodel-=stopsel

" Shell
set shell=pwsh.exe
set shellcmdflag=-noprofile\ -Nologo\ -noninteractive\ -command
set shellpipe=|
set shellredir=>

" Programs
let g:python_host_prog = 'C:\Python27\python.exe' 
let g:python3_host_prog = 'C:\Python38\python.exe' 
set pyx=3
let g:node_host_prog = 'C:\Users\flars\AppData\Roaming\npm\neovim-node-host.cmd' "C:\Program Files\nodejs\node.exe'

"Completion
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

inoremap <silent><expr> <c-space> coc#refresh()

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! CocCurrentFunction()
	return get(b:, 'coc_current_function', '')
endfunction

let g:coc_global_extensions = ['coc-vimlsp', 'coc-json', 'coc-yaml', 'coc-powershell', 'coc-omnisharp', 'coc-python', 'coc-spell-checker']

" Misc
set encoding=utf-8
scriptencoding utf-8

" Appearance
set relativenumber
set cursorline
set colorcolumn=80
colorscheme challenger_deep
if has('nvim') || has('termguicolors')
	set termguicolors
endif
let g:lightline = {
      \ 'colorscheme': 'challenger_deep',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste'  ],
      \	 	    [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \		     [ 'percent' ],
      \  	     [ 'fileformat' ],
      \		     [ 'cocstatus', 'currentfunction' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction',
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }
set noshowmode

autocmd FileType lisp,clojure,scheme,powershell,vim RainbowParentheses


" Mappings
let mapleader = "\<Space>"
inoremap jj <Esc>
