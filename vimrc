call pathogen#infect()
call pathogen#helptags()

syntax on
syntax enable
filetype plugin indent on
scriptencoding utf-8

set hlsearch
set nobackup
set nowritebackup
set noswapfile
set fencs=utf-8
set mouse=

" Robienie wciec
vnoremap > >gv
vnoremap < <gv

set pastetoggle=<F2>
set tabstop=2
set shiftwidth=2
set expandtab

set nu

set wildignore=*.dll,*.o,*.obj,*.bak,*.pyc,*.swp " ignore these"

"Po 3 spacjach po naciśnięciu tab idzie do 4 a nie do 5
set shiftround

map <C-p> <C-PageUp> 
map <C-n> <C-PageDown>

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

map <C-n> :NERDTreeToggle<CR>

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
set listchars=tab:▸\ ,eol:¬

"Invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

nnoremap ; :

" Cheat!
command! -complete=file -nargs=+ Cheat call Cheat(<q-args>)
function! Cheat(command)
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  execute 'silent $read !cheat '.escape(a:command,'%#')
  setlocal nomodifiable
endfunction
