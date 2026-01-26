" Uncomment to use Plug package manager
"call plug#begin('~/.vim/plugged')
"call plug#end()

"set cursorline
hi CursorLine term=none cterm=none ctermbg=black

highlight Comment ctermfg=green


syntax on

set number
set expandtab
set softtabstop=2
set tabstop=2
set shiftwidth=2


" Relative numbers only in normal mode
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave *
        \ if &buftype == '' | set relativenumber | endif
  autocmd BufLeave,FocusLost,InsertEnter *
        \ if &buftype == '' | set norelativenumber | endif
augroup END

"Favourites -> desert industry koehler
"colorscheme industry

"highlight Normal ctermfg=grey ctermbg=black

" =================== Indentation ======================
set smartindent
set autoindent
set smarttab

set ruler
set hlsearch
set ai
set autoread        "Reload files changed outside vim
set showcmd         "Show incomplete cmds down the bottom
set showmode        "Show current mode down the bottom


" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

set mouse=a


set paste

" ================ Turn Off Swap Files ==============
set noswapfile
set nobackup
set nowb


" ============= Copying ==================

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed

"set title
"set title
"set t_ts=\^[]6;
"set t_fs=^G
"set titlestring=%{bufname('%')==''?'':'file://'.hostname().expand('%:p:gs/\ /%20/')}
"set titlelen=0

nnoremap <leader>h :nohlsearch<CR>

