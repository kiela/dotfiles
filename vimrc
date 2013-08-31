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
" After 3 spaces and pressing tab it will be 4 spaces - not 5
set shiftround



map <C-p> <C-PageUp> 
map <C-n> <C-PageDown>
" ignore these
set wildignore=*.dll,*.o,*.obj,*.bak,*.pyc,*.swp

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" nerdtree
map <C-n> :NERDTreeToggle<CR>

" shortcut to rapidly toggle `set list`
set list
nmap <leader>l :set list!<CR>
set listchars=tab:▸\ ,eol:¬,nbsp:¶

" Colors!

"Invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" highlight the 80th column
highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
match OverLength /\%>80v.\+/


nnoremap ; :

" Cheat!
command! -complete=file -nargs=+ Cheat call Cheat(<q-args>)
function! Cheat(command)
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  execute 'silent $read !cheat '.escape(a:command,'%#')
  setlocal nomodifiable
endfunction
