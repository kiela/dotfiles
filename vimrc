call pathogen#infect()
call pathogen#helptags()

let mapleader = ','

syntax on
"syntax enable " TODO wtf is that for?
filetype plugin indent on

set encoding=utf-8 " output encoding that is shown in the terminal
set fileencoding=utf-8 " output encoding of the file that is written
set backspace=2 " TODO make backspace work like most other apps
set ruler " show current row and number at the right bottom of the screen
set number " display line numbers
set numberwidth=5 " reserve 5 characters for number line
set pastetoggle=<F2> " bind setting 'paste' on and off to F2 key
set nobackup " TODO do not create any backaup files
set noswapfile " TODO do not create any swap files
set nowritebackup" TODO wtf is that for?
"set fencs=utf-8 " TODO wtf is that for?
"set mouse= " TODO wtf is that for?
set autowrite " TODO automatically :write before running commands
set nojoinspaces " TODO use one space, not two, after punctuation
set diffopt+=vertical " always use vertical diffs
"set hidden " TODO switch between buffers without errors

"set textwidth=80 " wrap lines longer then 80 characters
" show "80-characters-line-long" vertical line
nmap <silent> <Leader>ll :set colorcolumn=81<CR>

set hlsearch " highlight searching word
" turn off search highlights
nmap <silent> <Leader>nn :nohlsearch<CR>

" indentations
vnoremap > >gv
vnoremap < <gv

" URL: https://vim.fandom.com/wiki/Converting_tabs_to_spaces
" tabstop - how many spaces replace a tab when tab is hit
" softtabstop -
" shiftwidth - how many spaces are used instead of tab when line is indetned
" expandtab - use spaces when tab is hit
" shiftround - after 3 spaces and pressing tab it will be 4 spaces - not 5
set tabstop=2 softtabstop=2 shiftwidth=2
set expandtab
set shiftround

if has("autocmd")
    autocmd FileType make setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
    autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType sh setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType zsh setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

    autocmd FileType ruby setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType groovy setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
    autocmd FileType erlang setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
    autocmd BufNewFile,BufRead *.app,*.app.src setfiletype erlang

    autocmd BufRead,BufNewFile Dockerfile* set filetype=dockerfile
    autocmd BufRead,BufNewFile Jenkinsfile* set filetype=groovy

    autocmd FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType haml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType css setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType sass setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType scss setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType coffee setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

    autocmd BufWritePre *.erl,*.rb :call <SID>StripTrailingSpaces()

    autocmd BufNewFile,BufRead *.sls setfiletype yaml

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
"match OverLength /\%>80v.\+/


nnoremap ; :

" Cheat!
command! -complete=file -nargs=+ Cheat call Cheat(<q-args>)
function! Cheat(command)
    botright new
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    execute 'silent $read !cheat '.escape(a:command,'%#')
    setlocal nomodifiable
endfunction
