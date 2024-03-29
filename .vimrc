set encoding=utf-8
scriptencoding utf-8

"==================================================================================================
" vundle configuration
"==================================================================================================
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.

" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'

" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'

" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

Plugin 'ervandew/supertab'

Plugin 'vim-scripts/OmniCppComplete'

Plugin 'ntpeters/vim-better-whitespace'

" Coding style: Linux kernel
Plugin 'vivien/vim-linux-coding-style'
" Coding style: auto-detect
Plugin 'tpope/vim-sleuth'

Plugin 'scrooloose/nerdtree'

Plugin 'changyuheng/color-scheme-holokai-for-vim'

Plugin 'kergoth/vim-bitbake'

Plugin 'vim-airline/vim-airline'
Plugin 'preservim/tagbar'

Plugin 'milkypostman/vim-togglelist'

Plugin 'thinca/vim-localrc'

Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-session'

Plugin 'andr2000/google.vim'

Plugin 'rust-lang/rust.vim'

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

"==================================================================================================
" All the rest
"==================================================================================================

" Allow mouse
:set mouse=a

" Bind contents of the visual selection to system primary buffer
set clipboard=unnamedplus

" Set options and add mapping such that Vim behaves a lot like MS-Windows
source $VIMRUNTIME/mswin.vim
behave mswin

" set spell spelllang=en_us
:hi clear SpellBad
:hi SpellBad cterm=underline,bold ctermfg=red

:set nofixendofline

:set number

:colorscheme holokai
:set background=light

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

set ignorecase " ignore case when searching
set smartcase  " ... except when search pattern contains an uppercase char


set autoindent
set smartindent
set cino+=(0

" Enable Linux Kernel coding style for the following folders:
let g:linuxsty_patterns = [ "/*linux*/", "/*kernel*/" ]

" Indent with Tab and Shift-Tab
:vmap <Tab> >
:vmap <S-Tab> <

" To have undo history while switching between buffers
:set hidden


"==================================================================================================
" Show tabs and spaces
"==================================================================================================
:set listchars=tab:>-,trail:~,extends:>,precedes:<,space:·
:hi SpecialKey ctermfg=237 guifg=grey70
:set list

"==================================================================================================
" Restore cursor position
"==================================================================================================
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") && &filetype != "gitcommit" |
    \ execute("normal `\"") |
  \ endif

"==================================================================================================
" 80 char lines
"==================================================================================================

:highlight ColorColumn ctermbg=8
if exists('+colorcolumn')
  set colorcolumn=81
else
  autocmd BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>81v.\+', -1)
endif

"==================================================================================================
" NERDTree
"==================================================================================================
let g:NERDTreeWinSize = 35

" Preserve scroll position when switching between buffers
autocmd BufLeave * if !&diff | let b:winview = winsaveview() | endif
autocmd BufEnter * if exists('b:winview') && !&diff | call winrestview(b:winview) | unlet! b:winview | endif

" Switch between NERDTree and opened file
:nmap \e :wincmd w<CR>

" Create new file in the same folder where current edited file is located
:nmap <C-N> :wincmd w<CR>ma

" Delete current file
" :nmap <C-D> :wincmd w<CR>md

" Switch between opened windows
:nmap <Tab> :bp<CR>

" Close current buffer
:nmap <expr> \q len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1 ? ':qa<CR>' : ':bp<CR>:bd #<CR>'

" Prevent Tab on NERDTree (breaks everything otherwise)
autocmd FileType nerdtree noremap <buffer> <Tab> <nop>

" calls NERDTreeFind iff NERDTree is active, current window contains a modifiable file, and we're not in vimdiff
function! s:syncTree()
  let s:curwnum = winnr()
  NERDTreeFind
  exec s:curwnum . "wincmd w"
endfunction

function! s:syncTreeIf()
  if (winnr("$") > 1)
    call s:syncTree()
  endif
endfunction

" Find the file in the project drawer
map <silent> <F3> :call <SID>syncTreeIf()<CR>
  
" Automatically close vim if only NERDTree left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  
" Synchronizes the tree with opened file when switching between opened windows
" after the default timeout of 4sec (http://vimdoc.sourceforge.net/htmldoc/options.html#'updatetime')
" autocmd CursorHold,CursorHoldI * call s:syncTreeIf()

" Show/Hide NERDTree
:nmap <expr> \a (winnr("$") == 1) ? ':NERDTreeFind<CR>' : ':wincmd o<CR>'
" Prevent this command activation in NERDTree
autocmd FileType nerdtree noremap <buffer> \a <nop>

"==================================================================================================
" Windows
"==================================================================================================

" Type gb in command mode: list open buffers and types :b , ready to start typing a buffer name/number
nnoremap gb :ls<cr>:b<space>

" do not close vim when closing a buffer with :bd, close current buffer with \q
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

"==================================================================================================
" OmniCppCompletion plugin
"==================================================================================================

set complete-=i

" Enable OmniCompletion
" http://vim.wikia.com/wiki/Omni_completion
filetype plugin on
set omnifunc=syntaxcomplete#Complete

" Configure menu behavior
" http://vim.wikia.com/wiki/VimTip1386
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Popup menu hightLight Group
highlight Pmenu ctermbg=7 guibg=LightGray
highlight PmenuSel ctermbg=14 guibg=DarkBlue guifg=White
highlight PmenuSbar ctermbg=7 guibg=DarkGray
highlight PmenuThumb guibg=Black

" enable global scope search
let OmniCpp_GlobalScopeSearch = 1
" show function parameters
let OmniCpp_ShowPrototypeInAbbr = 1
" show access information in pop-up menu
let OmniCpp_ShowAccess = 1
" auto complete after '.'
let OmniCpp_MayCompleteDot = 1
" auto complete after '->'
let OmniCpp_MayCompleteArrow = 1
" auto complete after '::'
let OmniCpp_MayCompleteScope = 0
" don't select first item in pop-up menu
let OmniCpp_SelectFirstItem = 0

"==================================================================================================
" ctags
"==================================================================================================

" http://vim.wikia.com/wiki/Show_tags_in_a_separate_preview_window
" This will make Control-] pop open a window and show the tag there.
" The :ptjump command shows the tag in a preview window without changing
" the current buffer or your cursor position.
" nnoremap <C-]> <Esc>:exe "ptjump " . expand("<cword>")<Esc>

" open window split vertically to the right, then navigate with Ctrl-] as usually
map <leader>] :rightb vsp <CR>:exec("tag ".expand("<cword>"))<CR>

"==================================================================================================
" git
"==================================================================================================
autocmd FileType gitcommit setlocal spell

" find merge conflict markers
nmap <silent> <leader>fc <ESC>/\v^[<=>]{7}( .*\|$)<CR>

autocmd FileType gitcommit
 \ set background=dark

"==================================================================================================
" Text files
"==================================================================================================
autocmd FileType text
  \ set spell |
  \ set background=dark

"==================================================================================================
" QuickfixEdit
"==================================================================================================
let g:toggle_list_no_mappings = 1
" mappings to jump between locations in a quickfix list, or
" differences if in window in diff mode
nnoremap <expr> <silent> <F7>   (&diff ? "]c" : ":cnext\<CR>")
nnoremap <expr> <silent> <F8> (&diff ? "[c" : ":cprev\<CR>")

nmap <script> <silent> <F6> :call ToggleQuickfixList()<CR>

"==================================================================================================
" TagBar
"==================================================================================================
nmap <F9> :TagbarToggle<CR>

"==================================================================================================
" Session handling
"==================================================================================================
let g:session_command_aliases = 1
let g:session_autosave = 'yes'
let g:session_autosave_to = 'default'
let g:session_autoload = 'no'
let g:session_autosave_silent = 'yes'

"==================================================================================================
" Open same file read-only in second Vim
" http://vim.wikia.com/wiki/Open_same_file_read-only_in_second_Vim
"==================================================================================================

let s:swapCheckEnabled = 1

let s:_shm = &shm
function! ToggleSwapCheck()
  let s:swapCheckEnabled = !s:swapCheckEnabled
  if !s:swapCheckEnabled
    let &shm = s:_shm
  endif
  aug CheckSwap
    au!
    if s:swapCheckEnabled
      set shm+=A
      au BufReadPre * call CheckSwapFile()
      au BufRead * call WarnSwapFile()
    endif
  aug END
endfunction
call ToggleSwapCheck()

function! CheckSwapFile()
  if !exists('*GetVimCmdOutput') || !&swapfile || !s:swapCheckEnabled
    return
  endif

  let swapname = GetVimCmdOutput('swapname')
  if swapname =~ '\.sw[^p]$'
    set ro
    let b:_warnSwap = 1
  endif
endfunction

function! WarnSwapFile()
  if exists('b:_warnSwap') && b:_warnSwap && &swapfile
    echohl ErrorMsg | echomsg "File: \"" . bufname('%') .
     \ "\" is opened readonly, as a swapfile already existed."
     \ | echohl NONE
    unlet b:_warnSwap
  endif
endfunction

"==================================================================================================
" YAML files
"==================================================================================================
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

"==================================================================================================
" VimEnter/VimLeave
"==================================================================================================
autocmd VimEnter *
	\ NERDTree |
	\ :wincmd w |
	\ call s:syncTree() |
	\ :winc = |
	\ :TagbarOpen

autocmd VimLeave *
	\ NERDTreeClose |
	\ call system("xclip -o | xclip -selection c")
