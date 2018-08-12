" ~/.config/nvim/init.vim
"
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

" " Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Initialize plugin system
call plug#end()


colorscheme desert

set termguicolors
sy on

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
set winminheight=0
set noequalalways
set winheight=9999
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

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd       " Show (partial) command in status line.
set showmatch     " Show matching brackets.
"set ignorecase   " Do case insensitive matching
"set smartcase    " Do smart case matching
set incsearch    " Incremental search
"set autowrite    " Automatically save before commands like :next and :make
"set hidden       " Hide buffers when they are abandoned
"set mouse=a      " Enable mouse usage (all modes)
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
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" https://github.com/mileszs/ack.vim
Plugin 'mileszs/ack.vim'
let g:ackprg = 'ag --vimgrep'

" fzf
set rtp+=~/.fzf
Plugin 'junegunn/fzf.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
