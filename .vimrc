if v:progname =~? "evim"
  finish
endif

set nocompatible

syntax on
set fileencodings=ucs-bom,utf-8,gb18030,cp936,big5,euc-jp,sjis,euc-kr,ucs-2le,latin1
set tabstop=4 softtabstop=4 shiftwidth=4 scrolloff=3 sidescrolloff=5 timeoutlen=350 mouse=
set modeline cindent expandtab cursorline number ignorecase wrap
set hlsearch incsearch showcmd ruler nobackup
set laststatus=2 statusline=\ %F%m%r\ \ \ %{getcwd()}%h\ \ \ Line:\ %l/%L:%c

set fileformat=unix fileencoding=utf-8

" 常用补充设置
set hidden
set backspace=indent,eol,start
set noerrorbells
set wildmenu
set whichwrap+=<,>,h,l

autocmd BufNewFile,BufRead Makefile setlocal noet
autocmd BufNewFile,BufRead makefile setlocal noet

set complete+=kidt

" F1 -> Esc，防止误触帮助
nnoremap <F1> <esc>
vnoremap <F1> <esc>
inoremap <F1> <esc>

if has('gui')
    set gfn=Monaco:h16
    nnoremap <C-S-V> "+p
    inoremap <C-S-V> <C-R>+
endif

" j/k 按屏幕行移动，限定 normal/visual mode，不影响 operator-pending
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

let mapleader=","

" select-all / copy / paste
nnoremap <leader>a ggVG
nnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <leader>f <c-w><c-f><c-w>T

" tab 操作
nnoremap <C-T> :tabedit<CR>
inoremap <C-T> <ESC>:tabedit<CR>i
nnoremap <TAB> :tabnext<CR>
nnoremap <S-TAB> :tabprevious<CR>

" Shift+Insert 粘贴（终端和 GUI 通用）
nnoremap  <S-Insert> "+p
vnoremap  <S-Insert> "+p
inoremap <S-Insert> <C-R>+
cnoremap <S-Insert> <C-R>+

" ,n 取消搜索高亮
nnoremap <leader>n :noh<cr>
