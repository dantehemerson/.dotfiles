call plug#begin('~/.vim/plugged')
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'preservim/nerdtree'
call plug#end()

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'
let g:airline_solarized_bg='dark'


" autocmd VimEnter * NERDTree
" autocmd BufWinEnter * NERDTreeMirror                          

" Togggle Tree with Ctrl+b
" nmap <C-b> :NERDTreeToggle<CR>

set cursorline
hi CursorLine term=none cterm=none ctermbg=black
set number
syntax on
set expandtab
set softtabstop=2
set tabstop=2
set shiftwidth=2
set smartindent
