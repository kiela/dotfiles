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

set nu
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
" After 3 spaces and pressing tab it will be 4 spaces - not 5
set shiftround

if has("autocmd")
	autocmd FileType make setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
	autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

	autocmd FileType ruby setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd FileType erlang setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd BufNewFile,BufRead *.app,*.app.src setfiletype erlang

	autocmd FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd FileType haml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd FileType css setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd FileType sass setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
endif


" ignore these
set wildignore=*.dll,*.o,*.obj,*.bak,*.pyc,*.swp

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
