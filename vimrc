" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes) in terminals

" Source a global configuration file if available
" XXX Deprecated, please move your changes here in /etc/vim/vimrc
set autoindent 
set smartindent
set cindent 
set backspace=2
set visualbell
set tabstop=4
set shiftwidth=4
set is
set number
set nocp
set textwidth=100
set wrap
set hlsearch
"set paste

"cscope
set csprg=/usr/bin/cscope
set csto=0
set cst
set nocsverb

filetype on
let Tlist_Ctags_Cmd="/usr/bin/ctags"
let Tlist_Inc_Winwidth=0
let Tlist_Exit_OnlyWindow=1

"if filereadable("~/work/timos2/cscope.out")
"	cs add ~/work/timos2/cscope.out
"else
"	cs add ./cscope.out
" endif
"
"set csverb
"set tags=~/work/timos2/tags,./tags

if filereadable("./cscope.out")
	cs add ./cscope.out
	set tags=./tags
else
	cs add /home/hjlee/work/tv_emulator/sdk/cscope.out
	set tags=./tags,/home/hjlee/work/tv_emulator/sdk/tags
endif

set csverb

func! Csc()
	let csc = expand("<cword>")
	new
	exe "cs find c ".csc
	if getline(1) == " "
		exe "q!"
	endif
endfunc
nmap ,c :call Csc()<cr>

syntax on

if $LANG[0] == 'k' && $lang1=='0'
set fileencoding=utf8
endif

if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

colorscheme evening 

