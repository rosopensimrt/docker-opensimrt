set mouse=n
syntax on

let g:tex_flavor='xelatex'

call plug#begin()

Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
	    \ Plug 'ryanoasis/vim-devicons'

Plug 'rafi/awesome-vim-colorschemes'

let g:NERDTreeFileExtensionHighlightFullName = 1

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
Plug 'tibabit/vim-templates'


Plug 'ryanoasis/vim-devicons'
set encoding=UTF-8
let g:airline_powerline_fonts = 1

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'christoomey/vim-tmux-navigator'

" loading the plugin
let g:webdevicons_enable = 1

" adding the flags to NERDTree
let g:webdevicons_enable_nerdtree = 1

" adding to vim-airline's tabline
let g:webdevicons_enable_airline_tabline = 1

" adding to vim-airline's statusline
let g:webdevicons_enable_airline_statusline = 1

" adding to flagship's statusline
let g:webdevicons_enable_flagship_statusline = 1

syntax enable


" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

Plug 'ycm-core/YouCompleteMe'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/vim-easy-align'
Plug 'https://github.com/junegunn/vim-github-dashboard.git'
let g:github_dashboard = { 'username': 'frederico-klein', 'password': $GITHUB_TOKEN }

Plug 'lervag/vimtex'
"Plug 'LaTeX-Suite-aka-Vim-LaTeX'

call plug#end()

let g:tmpl_search_paths = ['~/Templates']
colo molokai

function Test() range
  echo system('echo '.shellescape(join(getline(a:firstline, a:lastline), "\n")).'| pbcopy')
endfunction

" transparent background
hi Normal guibg=NONE ctermbg=NONE

filetype plugin indent on
set list
set listchars=eol:⏎,tab:␉·,trail:␠,nbsp:⎵

let g:vimtex_compiler_latexmk = { 
        \ 'executable' : 'latexmk',
        \ 'options' : [ 
        \   '-xelatex',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \ ],
        \}
colorscheme molokai
set guifont=DroidSansMono\ Nerd\ Font\ Mono\ 11

augroup tmux_ft
  au!
  autocmd BufNewFile,BufRead *.tmux   set syntax=bash
augroup END

augroup launch_ft
  au!
  autocmd BufNewFile,BufRead *.launch   set syntax=xml
augroup END
