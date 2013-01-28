let mapleader = ","

"call pathogen#runtime_append_all_bundles()
call pathogen#infect()
call pathogen#helptags()

let g:pymode_folding = 0
let g:pymode_lint_write = 0

filetype plugin indent on
set cursorline
set number

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

set mouse=a
set hidden
nnoremap <F1> :GundoToggle<CR>
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
set expandtab "tabs -> spaces


set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
map <F6> :set list!<CR>


func! WriteIfModified()
    if &modified
        write
    endif
endfunc

map <F7> :call WriteIfModified()<CR>:make<CR><CR><CR>:cc<CR><CR>
"map <F7> :make<CR><CR><CR>:cc<CR>
map <F8> :cp<CR>
map <F9> :cn<CR>
map <F5> :!clear; make run<CR><CR>

"map <F10> :!git diff %:p \|\| hg diff %:p<CR>
map <F10> :!(cd %:h; (git d %:t \|\| hg diff %:t))<CR>

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
"map <F5> :call Gotodefinition()<CR>
map gf :call Gotodefinition()<CR>

set pastetoggle=<F1>

func! ReloadCscope()
    "!cscope -Rb
    !rm -f cscope.out && (make cscope.out || cscope -Rb)
    cscope reset
    !ctags -R
endfunc

map <F2> :call ReloadCscope()<CR><CR><CR>
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

set noicon "don't change the window icon title
set notitle

if &term =~ '^screen'
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

func! Tab()
    set shiftwidth=8
    set tabstop=8
    set noexpandtab
endfunc

command -nargs=0 Tab :call Tab()

set modeline

"let showmarks_ignore_type="hqprm"
let showmarks_textlower="\t"
let g:Tlist_Show_One_File=1
filetype plugin on

fun! ReadMan()
    let s:man_word = expand('<cword>')
    " Open a new window:
    ":exe ":wincmd n"
    "
    let scr_bufnum = bufnr("__man__")
    if scr_bufnum == -1
        silent exe "vnew __man__"
    else
        " Scratch buffer is already created. Check whether it is open
        " in one of the windows
        let scr_winnum = bufwinnr(scr_bufnum)
        if scr_winnum != -1
            " Jump to the window which has the scratch buffer if we are not
            " already in that window
            if winnr() != scr_winnum
                exe scr_winnum . "wincmd w"
            endif
        else
            " Create a new scratch buffer
            exe "vsplit +buffer" . scr_bufnum
        endif
    endif

    ":vnew __man__
    " Assign current word under cursor to a script variable:
    :set buftype=nofile
    :set bufhidden=hide
    :setlocal noswapfile
    :setlocal nobuflisted
    :setlocal nowrap
    :map <buffer> q :bd<CR>
    :map <buffer> p p

    let $GROFF_NO_SGR=1
    " Read in the manpage for man_word (col -b is for formatting):
    :silent exe ":r!env man " . s:man_word . " | col -b"
    " Goto first line...
    :exe ":goto"
    " and delete it:
    :exe ":delete"
endfun
" Map the K key to the ReadMan function:
map <silent>  :call ReadMan()<CR>
runtime! ftplugin/man.vim
let $GROFF_NO_SGR=1

if filereadable("~/.vimrc.local")
    source ~/.vimrc.local
endif

