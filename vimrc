set cursorline

if has("gui_running")
	colorscheme ir_black
else
	hi CursorLine ctermbg=235 cterm=none
endif

set mouse=a
set hidden
"set cursorline
let mapleader = ","
map <F4> :NERDTreeToggle<CR>
map <F3> :NERDTreeFind<CR>

set ignorecase
set incsearch
set hlsearch

set autoindent
set smartindent
set shiftwidth=4
set ttyfast
set backspace=2
set numberwidth=3
set showbreak=@-->
set ruler
set tabstop=4
set wildmenu

map <F7> :w<CR>:make<CR><CR><CR>:cc<CR>
map <F8> :cp<CR>
map <F9> :cn<CR>
map <F5> :!clear; ./`make name`<CR>

set pastetoggle=<F1>

map <F2> :read !svn diff<CR>:set syntax=diff buftype=nofile<CR>gg

syntax on

set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

