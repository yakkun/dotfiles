syntax enable

set encoding=UTF-8
set fileencoding=UTF-8
set termencoding=UTF-8

set scrolloff=5
set noswapfile
set nowritebackup
set nobackup
set backspace=indent,eol,start
set vb t_vb=
set novisualbell
set list
set ruler
set nocompatible
set nostartofline
set matchpairs& matchpairs+=<:>
set showmatch
set matchtime=3
set wrap
set textwidth=0
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
set shiftround
set infercase
set hidden
set switchbuf=useopen
set ignorecase
set smartcase
set incsearch
set hlsearch
set number
set gdefault
set ruler
set showcmd
set wildmenu
set wildmode=list:longest
set wrapscan
set timeoutlen=300
" Indent
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set smartindent
" History
set undolevels=300
set history=10000
" IME
set iminsert=0
set imsearch=0
set imdisable
" Status line
set laststatus=2
set cmdheight=2

" Vim-Plug
call plug#begin('~/.vim/plugged')
Plug 'Shougo/unite.vim'
Plug 'pangloss/vim-javascript'
Plug 'jelera/vim-javascript-syntax'
Plug 'kchmck/vim-coffee-script'
Plug 'moll/vim-node'
Plug 'plasticboy/vim-markdown'
Plug 'vim-ruby/vim-ruby'
Plug 'kana/vim-textobj-user'
Plug 'rhysd/vim-textobj-ruby'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'
Plug 'tomtom/tcomment_vim'
Plug 'gregsexton/matchtag'
Plug 'stanangeloff/php.vim'
Plug 'leshill/vim-json'
Plug 'shougo/neocomplete.vim'
Plug 'chrisbra/csv.vim'
Plug 'othree/html5.vim'
Plug 'junegunn/vim-emoji'
Plug 'scrooloose/syntastic'
Plug 'hotchpotch/perldoc-vim'
Plug '9s/perlomni.vim'
Plug 'itchyny/lightline.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'bronson/vim-trailing-whitespace'
Plug 'violetyk/neocomplete-php.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

" Plugins conf
" Markdown
autocmd User BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
" Ruby
autocmd BufNewFile,BufRead *.jbuilder set filetype=ruby
autocmd BufNewFile,BufRead Guardfile  set filetype=ruby
autocmd BufNewFile,BufRead .pryrc     set filetype=ruby
autocmd FileType eruby exec 'set filetype=' . 'eruby.' . b:eruby_subtype
autocmd FileType ruby setl iskeyword+=?
au FileType ruby setlocal makeprg=ruby\ -c\ %
au FileType ruby setlocal errorformat=%m\ in\ %f\ on\ line\ %l
" PHP
au FileType php setlocal makeprg=php\ -l\ %
au FileType php setlocal errorformat=%m\ in\ %f\ on\ line\ %l
let php_folding = 0
let php_sql_query = 1
let php_baselib = 1
let php_htmlInStrings = 1
let php_noShortTags = 1
let php_parent_error_close = 1
let php_parent_error_open = 1
" Zen-Space highlight
function! ZenkakuSpace()
      highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=darkgrey
endfunction
if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
   augroup END
   call ZenkakuSpace()
endif
