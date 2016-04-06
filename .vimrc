if v:progname =~? "evim"
  finish
endif
    
set nocompatible

"------------------------------
"Start of Felix's customization

syntax on
"set autoindent
set fileencodings=ucs-bom,utf-8,gb18030,cp936,big5,euc-jp,sjis,euc-kr,ucs-2le,latin1
set tabstop=4 softtabstop=4 shiftwidth=4 scrolloff=3 sidescrolloff=5 timeoutlen=350 mouse=
set modeline cindent expandtab cursorline number ignorecase magic wrap
set hlsearch incsearch showcmd ruler nobackup
set laststatus=2 statusline=\ %F%m%r\ \ \ %{getcwd()}%h\ \ \ Line:\ %l/%L:%c

if has('win32')
    set termencoding=cp936 fileformat=dos fileencoding=cp936
    "set dir=C:\
else
    set fileformat=unix fileencoding=utf-8
    "set dir=/tmp
endif

autocmd BufNewFile,BufRead *.c call CPPSET()
autocmd BufNewFile,BufRead *.c setlocal makeprg=gcc\ -O2\ -Wall\ -Wno-unused-result\ -o\ %<.exe\ %

autocmd BufNewFile,BufRead *.cpp call CPPSET()
autocmd BufNewFile,BufRead *.php call PHPSET()
autocmd BufNewFile,BufRead *.java call JAVASET()
autocmd BufNewFile,BufRead *.py call PYSET()
autocmd BufNewFile,BufRead *.js call JSSET()
autocmd BufNewFile,BufRead *.scm call SCHEMESET()

autocmd BufNewFile,BufRead Makefile setlocal noet
autocmd BufNewFile,BufRead makefile setlocal noet

set complete+=kidt

func! CPPSET()
    setlocal cindent
    setlocal makeprg=g++\ -O2\ -Wall\ -Wno-unused-result\ -D__DEBUG__\ -o\ %<.exe\ %
    map <F9> :w!<cr>:make<cr><C-L>:cl<cr>
    map <F7> :!gdb %<.exe<cr><C-L>
    if has('win32')
        map <F8> :!start cmd /c "%<.exe && pause \|\| pause"<cr><cr><C-L>
    else
        if has('gui')
            map <F8> :!gnome-terminal --command="bash -c 'time \"./%<.exe\"; read -p \"  Press Enter...\"'"&<cr><cr><C-L>
        else
            map <F8> :!time ./%<.exe<cr>
        endif
    endif
    imap ppp printf("");<left><left><left>
    imap sss scanf("");<left><left><left>
    imap #inc  #include <><left>
endfunc

func! PYSET()
    if has('win32')
        map <F8> :w!<cr>:!start cmd /c "python % && pause \|\| pause"<cr><cr><C-L>
        map <C-F8> <esc><F8>
    else
        map <F9> <esc>:w!<cr>:!python -m py_compile %; rm -f %<.pyc<cr>
        map <F8> :w!<cr>:!python %<cr>
    endif
    setlocal expandtab
    map <F5> ggVGd<esc>:call PYTEMPLATE()<cr>Go
endfunc

func! PHPSET()
    "phpcs: php code sniffer (with psr2)
    map <F9> <esc>:w!<cr>:!php -l % && phpcs %<cr>
    setlocal cindent
    if has('win32')
        map <F8> <esc>:!start cmd /c "d:/web/php/php.exe % && pause \|\| pause"<cr><cr><C-L>
    else
        map <F8> <esc>:w!<cr>:!php %<cr>
    endif
endfunc!

func! JAVASET()
    setlocal makeprg=javac\ %
    setlocal cindent
    map <F9> :w!<cr>:make<cr><C-L>:cl<cr>
    "For windows, use
    if has('win32')
        map <F8> :!start cmd /c "java %< && pause \|\| pause"<cr><cr><C-L>
    else
        map <F8> :!time java "%<"; read -p "Press Enter..."&<cr><cr><C-L>
    endif
endfunc

func! JSSET()
    setlocal cindent
    map <F9> :w!<cr>:!jsl -process %<cr>
endfunc!

func! SCHEMESET()
    if has('win32')
        map <F8> :w!<cr>:!start cmd /c "guile % && pause \|\| pause"<cr><cr><C-L>
    else
        map <F8> :w!<cr>:!time guile %<cr>
    endif
    setlocal expandtab
endfunc

"map keys

noremap <F1> <esc>
vnoremap <F1> <esc>
inoremap <F1> <esc>
map <F2> <esc>:e ++enc=cp936<cr>
map <F3> <esc>:e ++enc=utf-8<cr>

imap <F2> <Esc><F2>
imap <F3> <Esc><F3>
imap <C-F9> <Esc><F9>
imap <F12> <Esc><F12>

if has('gui')
    set gfn=Monaco:h16
    map <C-S-V> "+p
    imap <C-S-V> <esc><C-S-V>
endif

noremap j gj
noremap k gk

let mapleader=","

" for select-all, copy, paste
map <leader>a ggVG
map <C-C> "+y
map <leader>p "+p
map <leader>f <c-w><c-f><c-w>T

map <C-T>  :tabedit<CR>
imap <C-T>  <ESC>:tabedit<CR>
map <TAB> :tabnext<CR>
map <S-TAB> <ESC>:tabprevious<CR>

" ,n for no highlight search(temporary)
nmap <leader>n <esc>:noh<cr>

" F12 to insert template
"map <F12> <Esc>ggdG:call Template()<cr>/main<cr>:noh<cr>jo
func! Template()
call setline(1,        "#include<iostream>")
call append(line('$'), "#include<algorithm>")
call append(line('$'), "#include<cstdio>")
call append(line('$'), "#include<cstdlib>")
call append(line('$'), "#include<cstring>")
call append(line('$'), "#include<set>")
call append(line('$'), "#include<map>")
call append(line('$'), "#include<vector>")
call append(line('$'), "using namespace std;")
call append(line('$'), "#ifdef __DEBUG__")
call append(line('$'), "#define dp(fmt, x...) fprintf(stderr, \"[%d] \" fmt, __LINE__, ##x)")
call append(line('$'), "#else")
call append(line('$'), "#define dp(fmt, x...)")
call append(line('$'), "#endif")
call append(line('$'), "")
call append(line('$'), "int main()")
call append(line('$'), "{")
call append(line('$'), "    return 0;")
call append(line('$'), "}")
call append(line('$'), "")
endfunc

func! PYTEMPLATE()
    call setline(1,        "#!/usr/bin/python")
    call append(line('$'), "#coding:utf-8")
    call append(line('$'), "")
    call append(line('$'), "import os")
    call append(line('$'), "import sys")
    call append(line('$'), "import time")
    call append(line('$'), "try:")
    call append(line('$'), "    import simplejson as json")
    call append(line('$'), "except:")
    call append(line('$'), "    import json")
    call append(line('$'), "")
endfunc

"End of Felix's customization
"----------------------------

set backspace=indent,eol,start
set history=50    " keep 50 lines of command line history
" Don't use Ex mode, use Q for formatting
map Q gq
if has("autocmd")
  filetype plugin indent on
  augroup vimrcEx
  au!
  "autocmd FileType text setlocal textwidth=78
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \  exe "normal! g`\"" |
    \ endif
  augroup END
else
  set cindent
endif " has("autocmd")

command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
    \ | wincmd p | diffthis

colorscheme desert
