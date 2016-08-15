" Vim syntax file
" Language: XKB (X Keyboard Extension) components
" Authors: 
"	David Nečas (Yeti) <yeti@physics.muni.cz>
"	Robbie Smith <zoqaeski@gmail.com>
" URI: http://opensource.apple.com/source/vim/vim-6/vim/runtime/syntax/xkb.vim


" Setup
if version >= 600
  if exists("b:current_syntax")
    finish
  endif
else
  syntax clear
endif

syn case match
syn sync minlines=100

" Comments
syn region xkbComment start="//" skip="\\$" end="$" keepend contains=xkbTodo
syn region xkbComment start="/\*" matchgroup=NONE end="\*/" contains=xkbCommentStartError,xkbTodo
syn match xkbCommentError "\*/"
syntax match xkbCommentStartError "/\*" contained
syn sync ccomment xkbComment
syn keyword xkbTodo TODO FIXME contained

" Literal strings
syn match xkbSpecialChar "\\\d\d\d\|\\." contained
syn region xkbString start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=xkbSpecialChar oneline

" Catch errors caused by wrong parenthesization
syn region xkbParen start='(' end=')' contains=ALLBUT,xkbParenError,xkbSpecial,xkbTodo transparent
syn match xkbParenError ")"
syn region xkbBrace start='{' end='}' contains=ALLBUT,xkbBraceError,xkbSpecial,xkbTodo transparent
syn match xkbBraceError "}"
syn region xkbBracket start='\[' end='\]' contains=ALLBUT,xkbBracketError,xkbSpecial,xkbTodo transparent
syn match xkbBracketError "\]"

" Physical keys
syn match xkbPhysicalKey "<\w\+>"

" Keywords
syn keyword xkbPreproc augment include replace
syn keyword xkbConstant False True
syn keyword xkbModif override replace
syn keyword xkbIdentifier action affect alias allowExplicit approx baseColor clearLocks color controls cornerRadius ctrls description driveskbd font fontSize gap group height indicator interpret key keys labelColor latchToLock left level_name map maximum minimum modifier_map modifiers name offColor onColor outline preserve priority repeat row section section shape slant solid symbols text top type useModMapMods virtualModifier virtualMods virtual_modifiers weight whichModState width
syn keyword xkbAction ISOLock LatchGroup LatchMods LockControls LockGroup LockMods NoAction SetControls SetGroup SetMods Terminate
syn keyword xkbTModif default hidden partial virtual
syn keyword xkbSect alphanumeric_keys alternate_group keypad_keys modifier_keys xkb_compatibility xkb_compat xkb_geometry xkb_keycodes xkb_keymap xkb_semantics xkb_symbols xkb_types

" Define the default highlighting
if version >= 508 || !exists("did_xkb_syntax_inits")
  if version < 508
    let did_xkb_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink xkbModif             xkbPreproc
  HiLink xkbTModif            xkbPreproc
  HiLink xkbPreproc           Preproc

  HiLink xkbIdentifier        Keyword
  HiLink xkbAction            Function
  HiLink xkbSect              Type
  HiLink xkbPhysicalKey       Identifier
  HiLink xkbKeyword           Keyword

  HiLink xkbComment           Comment
  HiLink xkbTodo              Todo

  HiLink xkbConstant          Constant
  HiLink xkbString            String

  HiLink xkbSpecialChar       xkbSpecial
  HiLink xkbSpecial           Special

  HiLink xkbParenError        xkbBalancingError
  HiLink xkbBraceError        xkbBalancingError
  HiLink xkbBraketError       xkbBalancingError
  HiLink xkbBalancingError    xkbError
  HiLink xkbCommentStartError xkbCommentError
  HiLink xkbCommentError      xkbError
  HiLink xkbError             Error

  delcommand HiLink
endif

let b:current_syntax = "xkb"
