set nocompatible              " be iMproved, required
filetype off                  " required

set number relativenumber
set noswapfile
set smartcase

" Enable GUI mouse behavior
" set mouse=a

set list
set listchars=trail:·

" split are to the right and bottom
set splitbelow
set splitright

" setup python paths
let g:python3_host_prog = "/usr/local/bin/python3"

if empty(glob("~/.vim/plug.vim"))
    execute '!curl -fLo ~/.vim/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif
source ~/.vim/plug.vim

call plug#begin('~/.vim/plugged')
" Fuzzy search through files and other stuff
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" NERD tree file browser
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" Git integration
Plug 'tpope/vim-fugitive'

" Python stuff
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'vim-scripts/vim-auto-save'
Plug 'bfredl/nvim-ipy'
call plug#end()


" set encoding
set encoding=utf8
set guifont=Inconsolata_Nerd_Font_Mono:h10

let g:auto_save = 1
let g:auto_save_in_insert_mode = 0
" Setup terminal mode
" Allow moving in between windows with Alt+hjkl independent of
" terminal mode
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Remap C-ESC to get out of terminal mode
tnoremap <C-ESC> <C-\><C-n>

" Disable regular arrow keys
noremap <up> <NOP>
noremap <down> <NOP>
noremap <left> <NOP>
noremap <right> <NOP>

" autocmd DirChanged * NERDTreeMapCWD
map <C-n> :NERDTreeToggle<CR>

" nnoremap <silent> K :call OniCommand('editor.quickInfo.show')
" let g:ipy_monitor_subchannel = 0
" let g:ipy_autostart = 0
" let g:ipy_perform_mappings = 0
" source ~/.vim/ipy.vim

" xmap <C-enter> <Plug>(IPython-RunLines)<CR>
" nmap <C-enter> <Plug>(IPython-RunLine)<CR>
" nmap <C-S-enter> <Plug>(IPython-RunCell)<CR>

let s:pydoc_path = 'pipenv run python -m pydoc'
nnoremap <silent> K :<C-u>let save_isk = &iskeyword \|
    \ set iskeyword+=. \|
    \ execute "Pyhelp " . expand("<cword>") \|
    \ let &iskeyword = save_isk<CR>
command! -nargs=1 -bar Pyhelp :call ShowPydoc(<f-args>)
function! ShowPydoc(what)
  let bufname = a:what . ".pydoc"
  " check if the buffer exists already
  if bufexists(bufname)
    let winnr = bufwinnr(bufname)
    if winnr != -1
      " if the buffer is already displayed, switch to that window
      execute winnr "wincmd w"
    else
      " otherwise, open the buffer in a split
      execute "sbuffer" bufname
    endif
  else
    " create a new buffer, set the nofile buftype and don't display it in the
    " buffer list
    execute "split" fnameescape(bufname)
    setlocal buftype=nofile
    setlocal nobuflisted
    " read the output from pydoc
    execute "r !" . s:pydoc_path . " " . shellescape(a:what, 1)
  endif
  " go to the first line of the document
  1
endfunction
