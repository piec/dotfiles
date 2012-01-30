call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

set cursorline
set number


if has("gui_running")
	"set guifont=DejaVu\ Sans\ Mono\ 9
	"set guifont=Droid\ Sans\ Mono\ 10
	if has("mac")
		set guifont=Monaco:h10
	elseif has("unix")
		set guifont=Fixed\ 10
	endif
	colorscheme ir_black
else
	if &t_Co == 256
		colorscheme tir_black
		hi CursorLine ctermbg=235 cterm=none
	endif
endif

set mouse=a
set hidden
"set cursorline
let mapleader = ","
nnoremap <F1> :GundoToggle<CR>
let g:qb_hotkey = "<S-F2>"
map <F2> :vertical wincmd f<CR>
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

"set expandtab "tabs -> spaces

set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
map <F6> :set list!<CR>

map <F7> :w<CR>:make<CR><CR><CR>:cc<CR>
map <F8> :cp<CR>
map <F9> :cn<CR>
map <F5> :!clear; ./`make name`<CR>

set pastetoggle=<F1>

"map <F2> :read !svn diff<CR>:set syntax=diff buftype=nofile<CR>gg

syntax on

if !has("ruby")
	let g:LustyExplorerSuppressRubyWarning = 1
endif

if v:version >= 703
	set undodir=~/.vim/undodir
	set undofile
	set undolevels=1000 "maximum number of changes that can be undone
	set undoreload=10000 "maximum number lines to save for undo on a buffer reload
endif

if &diff
	map < :diffget<CR>
	map > :diffput<CR>
endif


set ttymouse=xterm2

