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

Plugin 'vivien/vim-linux-coding-style'

Plugin 'scrooloose/nerdtree'

Plugin 'changyuheng/color-scheme-holokai-for-vim'

Plugin 'kergoth/vim-bitbake'

Plugin 'vim-airline/vim-airline'

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

"==================================================================================================
" Show tabs
"==================================================================================================
:set listchars=tab:>-,trail:~,extends:>,precedes:<
:hi SpecialKey ctermfg=grey guifg=grey70
:set list

"==================================================================================================
" Restore cursor position
"==================================================================================================
au BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") && &filetype != "gitcommit" |
    \ execute("normal `\"") |
  \ endif

"==================================================================================================
" 80 char lines
"==================================================================================================

:highlight ColorColumn ctermbg=7
if exists('+colorcolumn')
  set colorcolumn=81
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>81v.\+', -1)
endif

"==================================================================================================
" NERDTree
"==================================================================================================
let g:NERDTreeWinSize = 35

" Preserve scroll position when switching between buffers
au BufLeave * if !&diff | let b:winview = winsaveview() | endif
au BufEnter * if exists('b:winview') && !&diff | call winrestview(b:winview) | unlet! b:winview | endif


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
  
" Shows NERDTree on start and synchronizes the tree with opened file when switching between opened windows
" autocmd BufEnter * call s:syncTreeIf()
  
  
" Automatically close vim if only NERDTree left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  
" Focus on opened view after starting (instead of NERDTree)
autocmd VimEnter * call s:syncTree()
au VimEnter * :wincmd w

" Auto refresh NERDTree files
autocmd CursorHold,CursorHoldI * if (winnr("$") > 1) | call NERDTreeFocus() | call g:NERDTree.ForCurrentTab().getRoot().refresh() | call g:NERDTree.ForCurrentTab().render() | wincmd w | endif

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

au FileType gitcommit
 \ set background=dark
