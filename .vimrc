set nocompatible              " be iMproved
filetype off                  " required!

let g:lucius_style = 'light'
let g:lucius_contrast = 'high'

set runtimepath+=~/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'flazz/vim-colorschemes'

call neobundle#end()

filetype plugin indent on

NeoBundleCheck

autocmd FileType python setlocal completeopt-=preview " To disable full docstrng on top

set number " Fancy line numbers

" Specify that every buffer will be hidden instead of forcing to write/undo
" changes. It's more modern convention
set hidden

" Get rid of old Backup/Swap files conventions -now we have SVN for that and we
" are doing more than one task at time so it's crap
set nobackup
set noswapfile

" Leader for additionall commands
let mapleader = ","
let g:mapleader = ","

" Moar colors
set t_Co=256
" Moar history
set history=700
" Enable mouse only in visual mode (everyone have mouse=a but it screw up with
" putty mouse copy)
set mouse=v

" Pretty self explanatory - ommit asking what to do if file is opened
" externally
set autoread

" ignore case upon searching
set ignorecase
" smart searching
set smartcase
set hlsearch
set incsearch

" every regexp search includes that every character other than a-zA-Z0-9 and
" '_' have special meaning
set magic

" auto very-magic
:nnoremap / /\v
:nnoremap ? ?\v

" highlight matching brackets
set showmatch

set wildmenu
set wildmode=list:longest,full
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc

set foldmethod=indent
set foldlevel=99

" BUFFERS
" ===============================
  " Easier switch in buffers
nmap < :bp<CR>
nmap > :bn<CR>
" Close the current buffer
map <leader>bd :Bclose<cr>
" Close all the buffers
map <leader>ba :1,1000 bd!<cr>
" ===============================

" ==============================
" COLORS AND FONT
" ======================================
syntax enable
colorscheme lucius
set background=light


" ======================================

" ENCODIN
" =====================================
set encoding=utf8
" Use unix as the standard file type
set ffs=unix,dos,mac

"Indents
"spaces instead of tabs
set expandtab
set smarttab
" 1 tab  = 2 spaces "
set shiftwidth=2
set tabstop=2
set softtabstop=2
set ai " Autoindene
set ci " Copyindent
set si " Smartindent

"set wrap "Wrap line
"set textwidth=79 " for PEP8 convention that every line should not have more that 80 chars (for older terminals like)
"set colorcolumn=85
"set formatoptions=qrn1 "Check whats that

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Go to next line of editor instead of next line of text. It helps when line is
" not wrapped. It's more natural
nnoremap j gj
nnoremap k gk

set backspace=indent,eol,start
set gdefault " Automate change all occurences on line not only first
nnoremap <tab> %
vnoremap <tab> %

" VisualMode
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2
" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction
