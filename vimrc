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

" switch between buffers without errors
set hidden

" indentations
vnoremap > >gv
vnoremap < <gv

set pastetoggle=<F2>

set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
" after 3 spaces and pressing tab it will be 4 spaces - not 5
set shiftround

if has("autocmd")
	autocmd FileType make setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
	autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

	autocmd FileType ruby setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd FileType erlang setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
	autocmd BufNewFile,BufRead *.app,*.app.src setfiletype erlang

	autocmd FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd FileType haml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd FileType css setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd FileType sass setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd FileType scss setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
	autocmd FileType coffee setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

	autocmd BufWritePre *.erl,*.rb :call <SID>StripTrailingSpaces()

	autocmd Filetype gitcommit setlocal textwidth=72
	autocmd Filetype gitcommit setlocal spell
endif

nnoremap <silent> <F6> :g/^$/d<CR>
nnoremap <silent> <F5> :call <SID>StripTrailingSpaces()<CR>
function! <SID>StripTrailingSpaces()
	" save last search, and cursor position.
	let _s=@/
	let l = line(".")
	let c = col(".")
	" strip trailing spaces
	%s/\s\+$//e
	" restore previous search history, and cursor position
	let @/=_s
	call cursor(l, c)
endfunction


set nu

" ignore these
set wildignore=*.dll,*.o,*.obj,*.bak,*.pyc,*.swp

" Plugins

" NERDTree
map <silent> <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeShowHidden=1
let g:NERDTreeIgnore=['\.DS_Store$', '\.git$']
" open a NERDTree automatically when vim starts without any file
if has("autocmd")
  " Start NERDTree when Vim is started without file arguments.
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
end

" shortcut to rapidly toggle `set list`
nmap <C-l> :set list!<CR>
set listchars=tab:▸\ ,eol:¬,nbsp:¶

" Colors!

" invisible character colors
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
