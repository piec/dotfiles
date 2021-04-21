set nocompatible

" junegunn/vim-plug ----------------------------------------
call plug#begin('~/.vim/plugged')
Plug 'sjl/gundo.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'bling/vim-airline'
"Plug 'sessionman.vim'
Plug 'godlygeek/tabular'
Plug 'junegunn/vim-easy-align'
"Plug 'taglist.vim'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-fugitive'
Plug 'bronson/vim-visual-star-search'
Plug 'tpope/vim-sleuth'
"Plug 'vim-scripts/ShowMarks'
Plug 'vim-scripts/file-line'
"Plug 'jacquesbh/vim-showmarks'
Plug 'rhysd/vim-clang-format'
Plug 'vim-scripts/a.vim'
Plug 'airblade/vim-gitgutter'
"Plug 'mhinz/vim-signify'
"Plug 'L9'
"Plug 'FuzzyFinder'
"Plug 'w0rp/ale'
Plug 'piec/man.vim'
"Plug 'christoomey/vim-tmux-navigator'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
"Plug 'Shougo/unite.vim'
"Plug 'mileszs/ack.vim'
"Plug 'rking/ag.vim'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-dispatch'

"Plug 'rainux/vim-vala'
"Plug 'tfnico/vim-gradle'
"Plug 'kchmck/vim-coffee-script'
"Plug 'lukaszkorecki/CoffeeTags'
Plug 'elzr/vim-json'
Plug 'terryma/vim-expand-region'
Plug 'fatih/vim-go'
Plug 'Chiel92/vim-autoformat'
Plug 'cespare/vim-toml'

Plug 'lepture/vim-jinja'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'rust-lang/rust.vim'
Plug 'gcavallanti/vim-noscrollbar'
Plug 'derekwyatt/vim-scala'
Plug 'leafgarland/typescript-vim'
Plug 'ARM9/arm-syntax-vim'

" lsp
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
" lsp language support
Plug 'ryanolsonx/vim-lsp-typescript'
Plug 'ryanolsonx/vim-lsp-python'
Plug 'piec/vim-lsp-clangd'
" complete while you type:
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()

"------------------------------------------------

"let mapleader = ","
let mapleader = "\<Space>"

inoremap jk <ESC>
nnoremap Q <NOP>

nnoremap <C-p> :CtrlP<CR>
nnoremap <Leader>o :FZF<CR>
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
nmap <Leader>a :call fzf#vim#ag(expand('<cword>'))<CR>
nmap <Leader>A :Ag<CR>
nmap <Leader>g :Lines<CR>

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

" Complete with i_CTRL-X_CTRL-K
set dictionary=/usr/share/dict/usa

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

autocmd VimEnter * nested call RestoreSession()

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

if &term =~ '^screen' || &term =~ '^tmux'
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
    if has("mouse_sgr") | set ttymouse=sgr
    else | set ttymouse=xterm2 | endif
endif

if has("mouse_sgr") | set ttymouse=sgr | endif

if &term =~ '^screen' || &term =~ '^xterm' || &term =~ '^tmux'
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

let g:sleuth_neighbor_limit=2

"------------------------------------------------

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
        "set guifont=Fixed\ Medium\ Semi-Condensed\ 10
        "set guifont=Misc\ Fixed\ Medium\ Semi-Condensed\ 10
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
let g:gundo_prefer_python3 = 1
nnoremap <F1> :GundoToggle<CR>
"map <F2> :vertical wincmd f<CR>
map <F4> :NERDTreeToggle<CR>
map <F3> :NERDTreeFind<CR>


func! WriteIfModified()
    if &modified
        write
    endif
endfunc

map <F7> :call WriteIfModified()<CR>:Make<CR><CR><CR>:cc<CR><CR>
"map <F7> :make<CR><CR><CR>:cc<CR>
map <F8> :cp<CR>
map <F9> :cn<CR>
"map <F6> :Make run

map <F10> :!(cd %:h; (git d %:t \|\| hg diff %:t))<CR>
"map <F11> :GitGutterLineHighlightsToggle<CR>
"imap <F11> <C-O>:GitGutterLineHighlightsToggle<CR>
vmap <Tab> >gv
vmap <S-Tab> <gv
vnoremap <C-c> "+y<Esc><Esc>

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

"map <F2> :call ReloadCscope()<CR><CR><CR>
"map <F2> :read !svn diff<CR>:set syntax=diff buftype=nofile<CR>gg


let showmarks_ignore_type="hqprm"
let showmarks_textlower="\t"
let showmarks_include="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
filetype plugin on

" Taglist
map <F5> :TagbarToggle<CR>
imap <F5> <C-O>:TagbarToggle<CR>
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

"let g:gitgutter_realtime = 0
"let g:gitgutter_enabled = 0
let g:gitgutter_map_keys = 0
nmap <F2> :GitGutterToggle<CR>

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(LiveEasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
"nmap <Leader>a <Plug>(LiveEasyAlign)

"map dn ]c
map Y "0P

set noshowmode
"let g:airline_theme='powerlineish'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_error=''
let g:airline_section_warning=''
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#wordcount#enabled = 0

call airline#parts#define_function('sleuth', 'SleuthIndicator')
let g:airline_section_y = airline#section#create_right(['ffenc','sleuth'])

function NoScrollBarIfInstalled()
  if exists('g:noscrollbar_loaded')
    function! HighResScrollbar(...)
      return noscrollbar#statusline(15,'-','█',['▐'],['▌'])
    endfunction
    call airline#parts#define_function('noscrollbar', 'HighResScrollbar')
    let g:airline_section_z = airline#section#create_right(['noscrollbar'])

    execute "AirlineRefresh"
  endif
endfunction
autocmd VimEnter * call NoScrollBarIfInstalled()

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

if ! has('nvim')
    "set clipboard=exclude:.*
endif

let g:go_bin_path = $HOME . "/apps/gotools-vim/"
"au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>r <Plug>(go-referrers)
au FileType go nmap <F2> <Plug>(go-rename)
"au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
au FileType go nmap <Leader>g <Plug>(go-def)
au FileType go nmap <leader>v <Plug>(go-def-vertical)

"let g:autoformat_verbosemode = 1
let g:autoformat_autoindent = 0
let g:formatdef_clangformat = "'clang-format -lines='.a:firstline.':'.a:lastline.' --assume-filename='.bufname('%')"
nmap <Leader>f :Autoformat<CR>
vmap F :Autoformat<CR>

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

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

let g:gitgutter_map_keys = 0
nmap <Leader>n :GitGutterNextHunk<CR>

let g:vim_json_syntax_conceal = 0

" -----

"let g:asyncomplete_auto_popup = 0

"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': '‼'}
let g:lsp_signs_hint = {'text': 'H'}
"let g:lsp_diagnostics_enabled = 0         " disable diagnostics support
"let g:lsp_highlights_enabled = 0
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
"let g:lsp_textprop_enabled = 0
let g:lsp_highlight_references_enabled = 1

let g:asyncomplete_auto_popup = 0

function! s:on_lsp_buffer_enabled() abort
  imap <c-space> <Plug>(asyncomplete_force_refresh)
  imap <c-@> <Plug>(asyncomplete_force_refresh)
  setlocal omnifunc=lsp#complete
  nmap <leader>d :LspDocumentDiagnostics<CR>
  nmap <leader>g :LspDefinition<CR>
  nmap <leader>G :LspDeclaration<CR>
  nmap <leader>r :LspReferences<CR>
  nmap <Leader>v :LspHover<CR>
  nmap <Leader>f :LspDocumentFormat<CR>
  vmap F :LspDocumentRangeFormat<CR>
  highlight lspReference ctermbg=240 guibg=gray "ctermfg=red guifg=red 
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

