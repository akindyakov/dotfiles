" ~/.config/nvim/init.vim

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
