" Vundle ----------------------------------------

set nocompatible
filetype off

set runtimepath+=~/.vim/bundle/vundle
call vundle#begin()

Bundle 'gmarik/vundle'
Bundle 'sjl/gundo.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'bling/vim-airline'
Bundle 'bling/vim-bufferline'
"Bundle 'Lokaltog/vim-powerline'
"Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
"Bundle 'klen/python-mode'
"Bundle 'sessionman.vim'
Bundle 'godlygeek/tabular'
Bundle 'junegunn/vim-easy-align'
Bundle 'taglist.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'bronson/vim-visual-star-search'
Bundle 'piec/detectindent.vim'
Bundle 'vim-scripts/ShowMarks'
Bundle 'Valloric/YouCompleteMe'
"Bundle 'Rip-Rip/clang_complete.git'
"Bundle 'rhysd/vim-clang-format'
Bundle 'vim-scripts/a.vim'
Bundle 'safetydank/vim-gitgutter'
Bundle 'sjbach/lusty'
"Bundle 'L9'
"Bundle 'FuzzyFinder'
Bundle 'scrooloose/syntastic'
Bundle 'piec/man.vim'
Bundle 'christoomey/vim-tmux-navigator'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-surround'
"Bundle 'Shougo/unite.vim'

"Bundle 'rainux/vim-vala'
"Bundle 'tfnico/vim-gradle'
"Bundle 'kchmck/vim-coffee-script'

call vundle#end()
filetype plugin indent on

"------------------------------------------------

let mapleader = ","

syntax on

set exrc
set secure
set viminfo=!,'100,\"100,:100,<100,s10,h,%

set showcmd
set display+=lastline

set hidden
set mouse=a

set ignorecase
set incsearch
set hlsearch

set backspace=2
set wildmenu
"set wildmode=longest:full
set ruler

set splitright
set cursorline
set number
set numberwidth=3

set autoindent
set smarttab
set smartindent
set tabstop=4
set shiftwidth=0 " =tabstop
set softtabstop=-1 " =shiftwidth
set expandtab "tabs -> spaces
set shiftround

set showmatch
"set showbreak=@-->
set showbreak=…

set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
map <F6> :set list!<CR>
set laststatus=2

set pastetoggle=<F1>
set formatprg=par\ -w80q

"------------------------------------------------

function! RestoreCursor()
    if line("'z") > 0
        normal 'zz
    endif
    if line("'\"") <= line("$")
        normal! g'"
        return 1
    endif
endfunction

function! SaveCursor()
    exec line("w0")."mark z"
endfunction

augroup RestoreCursor
    autocmd!
    autocmd BufReadPost * call RestoreCursor()
    autocmd BufWinLeave * call SaveCursor()
augroup END

"------------------------------------------------

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

set ttyfast
"set ttymouse=xterm2
set noicon "don't change the window icon title
set notitle
set modeline

if &term =~ '^screen'
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
    set ttymouse=sgr
endif

"------------------------------------------------

func! Tab()
    set shiftwidth=8
    set tabstop=8
    set noexpandtab
endfunc

command -nargs=0 Tab :call Tab()

command -nargs=1 -complete=help H :vert :h <args>

"------------------------------------------------

"let g:detectindent_verbosity = 0
let g:detectindent_preferred_indent = 4
let g:detectindent_preferred_expandtab = 1
autocmd BufReadPost * if exists("loaded_detectindent") | exe "DetectIndent" | endif

"------------------------------------------------

let g:pymode_folding = 0
let g:pymode_lint_write = 0


if !empty($KERNELDIR)
    set path=$KERNELDIR/include " ^= to prepend
    if !empty($ARCH)
        set path+=$KERNELDIR/include/asm-$ARCH
        set path+=$KERNELDIR/arch/$ARCH/include
    endif
endif
if isdirectory("/usr/targets/current/root/usr/include")
    set path+=/usr/targets/current/root/usr/include
    set path+=/usr/targets/current/root/usr/include/nexus
end

if has("gui_running")
    "set guifont=DejaVu\ Sans\ Mono\ 9
    "set guifont=Droid\ Sans\ Mono\ 10
    if has("mac")
        set guifont=Monaco:h10
    elseif has("unix")
        set guifont=Fixed\ Medium\ Semi-Condensed\ 10
        "set guifont=MiscFixed\ Semi-Condensed\ 10
    endif
    colorscheme ir_black
else
    if &t_Co == 256
        colorscheme tir_black
        hi CursorLine ctermbg=235 cterm=none
    endif

    inoremap <C-@> <C-x><C-o>
endif
nnoremap <F1> :GundoToggle<CR>
map <F2> :vertical wincmd f<CR>
map <F4> :NERDTreeToggle<CR>
map <F3> :NERDTreeFind<CR>


func! WriteIfModified()
    if &modified
        write
    endif
endfunc

map <F7> :call WriteIfModified()<CR>:make<CR><CR><CR>:cc<CR><CR>
"map <F7> :make<CR><CR><CR>:cc<CR>
map <F8> :cp<CR>
map <F9> :cn<CR>
"map <F5> :!clear; make run<CR><CR>

map <F10> :!(cd %:h; (git d %:t \|\| hg diff %:t))<CR>
"map <F11> :GitGutterLineHighlightsToggle<CR>
"imap <F11> <C-O>:GitGutterLineHighlightsToggle<CR>
vmap <Tab> >gv
vmap <S-Tab> <gv

func! Gotodefinition()
    ":map <F6> :vs<CR><C-w>w:csc find g <cword><CR>
    let found = globpath(&path, expand('<cfile>'))
    if empty(found)
        let file_path = expand('%:h')."/".expand('<cfile>')
        if filereadable(file_path)
            exec "e ".file_path
        else
            ":vs
            ":wincmd w
            csc find g <cword>
        endif
    else
        normal gF
    endif
endfunc
map gf :call Gotodefinition()<CR>

func! ReloadCscope()
    "!cscope -Rb
    !rm -f cscope.out && (make cscope.out || cscope -Rb)
    cscope reset
    !ctags -R
endfunc

map <F2> :call ReloadCscope()<CR><CR><CR>
"map <F2> :read !svn diff<CR>:set syntax=diff buftype=nofile<CR>gg


if !has("ruby")
    let g:LustyExplorerSuppressRubyWarning = 1
endif

let showmarks_ignore_type="hqprm"
let showmarks_textlower="\t"
let showmarks_include="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
filetype plugin on

" Taglist
map <F5> :TlistToggle<CR>
imap <F5> :TlistToggle<CR>
vmap <F5> :TlistToggle<CR>

let g:Tlist_Show_One_File=1
let g:Tlist_Auto_Open=0
set updatetime=250
"autocmd VimEnter * :TlistToggle

nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

if filereadable($HOME . "/.vimrc.local")
    source $HOME/.vimrc.local
endif

let g:gitgutter_realtime = 0
let g:gitgutter_enabled = 0

map <space> f 
vmap <space> f 

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(LiveEasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
nmap <Leader>a <Plug>(LiveEasyAlign)

"map dn ]c
map Y "0P

let g:airline_theme='powerlineish'
let g:airline_left_sep=''
let g:airline_right_sep=''
