" ~/.config/nvim/init.vim

" Plugin manager: https://github.com/junegunn/vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
set rtp+=~/.local/share/nvim/site/autoload/plug.vim
call plug#begin('~/.local/share/nvim/plugged')
" Make sure you use single quotes

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'rking/ag.vim'

" Rust development
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'

" Javascript development
"
" JS sytax highlighting
Plug 'pangloss/vim-javascript'

Plug 'ternjs/tern_for_vim', {'do': 'yarn && yarn global add tern'}

" Initialize plugin system
call plug#end()

"----------- vim-racer -------------------------
set hidden
let g:racer_cmd = "/home/akindyakov/.cargo/bin/racer"
let g:racer_experimental_completer = 1

au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gD <Plug>(rust-doc)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
"----------- end vim-racer -------------------------

"--- Javascript development plugin set up ---
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1
"--- end ---


"-----------theme -------------------------
colorscheme desert
set termguicolors
sy on
"-----------end theme ---------------------

set fileencodings=utf8,cp1251,koi8r,cp866,ucs-2le
set encoding=utf8
set iminsert=0
set imsearch=0
set hlsearch
set is

" set max text width (0 -- switch off)
set textwidth=0

" lines number switch on
set number
set autoread

if exists('+colorcolumn')
    set colorcolumn=81
    au InsertEnter * hi ColorColumn ctermbg=lightblue
endif

set expandtab
set nolinebreak
set dy=lastline
set list
set listchars=trail:_,tab:>-

" show status line
set laststatus=2
" status line format
set statusline=%f%m%r%h%w\ %y\ buf:%n%=col:%2c\ line:%2l/%L\ [%2p%%]

" change colors of status line for insert mode
au InsertEnter * highlight StatusLine cterm=bold ctermfg=black ctermbg=Grey
au InsertLeave * highlight StatusLine cterm=bold ctermfg=black ctermbg=Cyan

" display the buffer name in window title
set title

set clipboard=unnamed

" highlight trailing spaces
au BufNewFile,BufRead * let b:mtrailingws=matchadd('ErrorMsg', '\s\+$', -1)

" strip space chars from end of lines
com RStrip :%s/\s\+$//e

" Current date insertion
com Now put =strftime('%Y.%m.%d/%H:%M')
com Today put =strftime('%Y.%m.%d')


" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd       " Show (partial) command in status line.
set showmatch     " Show matching brackets.
"set ignorecase   " Do case insensitive matching
"set smartcase    " Do smart case matching
set incsearch    " Incremental search
set autowrite    " Automatically save before commands like :next and :make
"set hidden       " Hide buffers when they are abandoned
set mouse=a      " Enable mouse usage (all modes)
set mousehide     " hide the mouse cursor wheh text are imputed
set tabstop=2
set shiftwidth=2
set softtabstop=2
set scrolljump=1
set scrolloff=3

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.out,*.so

" Turn on the WiLd menu
set wildmenu

set nocompatible              " be iMproved, required

filetype plugin indent on    " required
