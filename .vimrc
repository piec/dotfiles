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
"Bundle 'bling/vim-bufferline'
"Bundle 'Lokaltog/vim-powerline'
"Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
"Bundle 'klen/python-mode'
"Bundle 'sessionman.vim'
Bundle 'godlygeek/tabular'
Bundle 'junegunn/vim-easy-align'
"Bundle 'taglist.vim'
Bundle 'majutsushi/tagbar'
Bundle 'tpope/vim-fugitive'
Bundle 'bronson/vim-visual-star-search'
Bundle 'piec/detectindent.vim'
Bundle 'vim-scripts/ShowMarks'
"Bundle 'Valloric/YouCompleteMe'
"Bundle 'Rip-Rip/clang_complete.git'
"Bundle 'rhysd/vim-clang-format'
Bundle 'vim-scripts/a.vim'
Bundle 'safetydank/vim-gitgutter'
"Bundle 'sjbach/lusty'
"Bundle 'L9'
"Bundle 'FuzzyFinder'
Bundle 'scrooloose/syntastic'
Bundle 'piec/man.vim'
"Bundle 'christoomey/vim-tmux-navigator'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-surround'
"Bundle 'Shougo/unite.vim'
"Bundle 'mileszs/ack.vim'
Bundle 'rking/ag.vim'
Bundle 'tpope/vim-obsession'

"Bundle 'rainux/vim-vala'
"Bundle 'tfnico/vim-gradle'
"Bundle 'kchmck/vim-coffee-script'
Bundle 'elzr/vim-json'
Bundle 'terryma/vim-expand-region'
Bundle 'fatih/vim-go'
Bundle 'Chiel92/vim-autoformat'

Bundle 'lepture/vim-jinja'
Bundle 'ConradIrwin/vim-bracketed-paste'
Bundle 'rust-lang/rust.vim'
"Bundle 'lornix/vim-scrollbar'
"Bundle 'derekwyatt/vim-scala'
"Bundle 'leafgarland/typescript-vim'
"Bundle 'ARM9/arm-syntax-vim'

call vundle#end()
filetype plugin indent on

"------------------------------------------------

"let mapleader = ","
let mapleader = "\<Space>"

inoremap jk <ESC>
nnoremap Q <NOP>

nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>w :w<CR>

nmap <Leader><Leader> V

nmap <Leader>b :CtrlPBuffer<CR>

nmap <Leader>j <C-w>j
nmap <Leader>k <C-w>k
nmap <Leader>h <C-w>h
nmap <Leader>l <C-w>l
nmap <Leader>J <C-w>J
nmap <Leader>K <C-w>K
nmap <Leader>H <C-w>H
nmap <Leader>L <C-w>L
nmap <Leader>= <C-w>=
nmap <Leader>a :Ag<CR>

nmap <Leader>x <C-w>c
nmap <Leader>$ :qa<CR>

"------------------------------------------------

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
if v:version >= 704
    set shiftwidth=0 " =tabstop
    set softtabstop=-1 " =shiftwidth
else
    set shiftwidth=4
    set softtabstop=4
endif
set expandtab "tabs -> spaces
set shiftround

set showmatch
if $LANG =~ "utf8"
    set showbreak=…
else
    set showbreak=@-->
endif

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

function! RestoreSession()
    if argc() == 0
        if filereadable('Session.vim')
            silent source Session.vim
        endif
    endif
endfunction

autocmd VimEnter * call RestoreSession()

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
    if has("mouse_sgr") | set ttymouse=sgr
    else | set ttymouse=xterm2 | endif
endif

if &term =~ '^screen' || &term =~ '^xterm'
    let &t_SI = "\<Esc>[6 q"
    if v:version > 704 || v:version == 704 && has('patch687')
        let &t_SR = "\<Esc>[4 q"
    endif
    let &t_EI = "\<Esc>[2 q"
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
let g:pymode_lint_on_write = 0
let g:pymode_rope_regenerate_on_write = 0
"let g:pymode_checkers = ['pep8']
let g:pymode_options_colorcolumn = 0
let g:pymode_trim_whitespaces = 0
let g:pymode_syntax_space_errors = 0


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
    set bg=dark
    colorscheme ir_black
else
    if &t_Co == 256
    set bg=dark
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
map <F5> :TagbarToggle<CR>
imap <F5> :TagbarToggle<CR>
vmap <F5> :TagbarToggle<CR>
let g:tagbar_sort = 0
"let g:tagbar_left = 0

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

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(LiveEasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
"nmap <Leader>a <Plug>(LiveEasyAlign)

"map dn ]c
map Y "0P

"let g:airline_theme='powerlineish'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_error=''
let g:airline_section_warning=''
let g:airline#extensions#whitespace#enabled = 0

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

if ! has('nvim')
    "set clipboard=exclude:.*
endif

au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
au FileType go nmap <Leader>g <Plug>(go-def)
au FileType go nmap <leader>v <Plug>(go-def-vertical)

"au FileType c nmap <Leader>g :YcmCompleter GoToDefinition<CR>
"au FileType c nmap <Leader>i :YcmCompleter GoToInclude<CR>
"au FileType c nmap <Leader>d :YcmCompleter GoToDeclaration<CR>
"au FileType c nmap <Leader>t :YcmCompleter GetType<CR>
"au FileType c nmap <Leader>t :YcmCompleter GetType<CR>

let g:LustyExplorerDefaultMappings = 0
nmap <silent> <Leader>uf :LustyFilesystemExplorer<CR>
nmap <silent> <Leader>ur :LustyFilesystemExplorerFromHere<CR>
nmap <silent> <Leader>ub :LustyBufferExplorer<CR>
nmap <silent> <Leader>ug :LustyBufferGrep<CR>

"let g:autoformat_verbosemode = 1
let g:autoformat_autoindent = 0
let g:formatdef_clangformat = "'clang-format -lines='.a:firstline.':'.a:lastline.' --assume-filename='.bufname('%')"
nmap <Leader>f :Autoformat<CR>
vmap F :Autoformat<CR>

let g:ycm_min_num_of_chars_for_completion = 100

" -----

command! CloseHiddenBuffers call s:CloseHiddenBuffers()
function! s:CloseHiddenBuffers()
  let open_buffers = []

  for i in range(tabpagenr('$'))
    call extend(open_buffers, tabpagebuflist(i + 1))
  endfor

  for num in range(1, bufnr("$") + 1)
    if buflisted(num) && index(open_buffers, num) == -1
      exec "bdelete ".num
    endif
  endfor
endfunction

" -----

let g:bracketed_paste_tmux_wrap = 0

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
