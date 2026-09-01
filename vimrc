" Load pathogen when present, stay quiet when it is not. `silent!` still
" triggers the autoload (so pathogen actually runs when installed) but
" suppresses E117 on a fresh machine without ~/.vim/autoload/pathogen.vim -
" unlike exists('*pathogen#infect'), which does not autoload and so was
" always false, silently disabling pathogen and every bundle.
silent! call pathogen#infect()
silent! call pathogen#helptags()

let mapleader = ','

syntax on
"syntax enable " TODO: wtf is that for?
filetype plugin indent on

set encoding=utf-8 " output encoding that is shown in the terminal
set fileencoding=utf-8 " output encoding of the file that is written
set backspace=indent,eol,start " backspace over indent, line ends, insert start
set ruler " show current row and number at the right bottom of the screen
set number " display line numbers
set numberwidth=5 " reserve 5 characters for number line
set pastetoggle=<F2> " bind setting 'paste' on and off to F2 key
set nobackup " TODO: do not create any backaup files
set noswapfile " TODO: do not create any swap files
set nowritebackup" TODO: wtf is that for?
set mouse= " let the terminal own the mouse, so select/copy stays native
set autowrite " TODO: automatically :write before running commands
set nojoinspaces " TODO: use one space, not two, after punctuation
set diffopt+=vertical " always use vertical diffs
set hidden " switch away from a modified buffer without saving it first
set maxmempattern=8192 " increase mximum amount of memory (in Kbyte) to use for pattern matching
set modeline " allow to set variables specific to a file i.e. # vim: ft=conf :
set modelines=5 " numer of lines that are checked for set commands

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

autocmd FileType make setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType sh setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType zsh setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType ruby setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType groovy setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType erlang setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd BufNewFile,BufRead *.app,*.app.src setfiletype erlang

autocmd BufRead,BufNewFile Dockerfile* set filetype=dockerfile
autocmd BufRead,BufNewFile Jenkinsfile* set filetype=groovy

autocmd BufNewFile,BufRead *.sls setfiletype yaml

autocmd BufRead,BufNewFile *.gitconfig setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd Filetype gitcommit setlocal textwidth=72
autocmd Filetype gitcommit setlocal spell
autocmd FileType markdown setlocal spell

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

augroup StripTrailingSpaces
  autocmd!
  autocmd BufWritePre * if &filetype != 'markdown' | call <SID>StripTrailingSpaces() | endif
augroup END

" Create the parent directory of a new file on save, so writing
" some/new/dir/file.txt does not fail with E212 just because the
" directory does not exist yet.
function! <SID>MkdirOnWrite(dir)
  " skip unnamed buffers and non-file protocols (scp://, fugitive://, ...)
  if empty(a:dir) || a:dir =~# '^\a\+://'
    return
  endif

  if !isdirectory(a:dir)
    call mkdir(a:dir, 'p')
  endif
endfunction

augroup MkdirOnWrite
  autocmd!
  autocmd BufWritePre * call <SID>MkdirOnWrite(expand('<afile>:p:h'))
augroup END

" Briefly highlight whatever was just yanked. Neovim has
" vim.highlight.on_yank for this, Vim does not - so match the yanked
" range by hand and drop the match again on a timer.
if exists('##TextYankPost') && has('timers')
  function! <SID>ClearYankHighlight(ids)
    for l:id in a:ids
      silent! call matchdelete(l:id)
    endfor
  endfunction

  function! <SID>HighlightYank()
    if get(v:event, 'operator', '') !=# 'y'
      return
    endif

    let l:start = getpos("'[")
    let l:end = getpos("']")

    " a big yank would need one match per line, skip the flash instead
    if l:end[1] - l:start[1] > 100
      return
    endif

    let l:ids = []
    if get(v:event, 'regtype', '') ==# 'v' && l:start[1] == l:end[1]
      " charwise inside one line, so highlight just those columns
      let l:pos = [l:start[1], l:start[2], l:end[2] - l:start[2] + 1]
      call add(l:ids, matchaddpos('IncSearch', [l:pos]))
    else
      for l:lnum in range(l:start[1], l:end[1])
        call add(l:ids, matchaddpos('IncSearch', [[l:lnum]]))
      endfor
    endif

    call timer_start(200, {-> s:ClearYankHighlight(l:ids)})
  endfunction

  augroup HighlightYank
    autocmd!
    autocmd TextYankPost * call <SID>HighlightYank()
  augroup END
endif


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
if has("autocmd")
  " Start NERDTree when Vim is started without file arguments.
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

  " Colors
  autocmd VimEnter * highlight NERDTreeDir guifg=NONE ctermfg=cyan
  autocmd VimEnter * highlight NERDTreeFile guifg=NONE ctermfg=NONE
  autocmd VimEnter * highlight NERDTreeLinkTarget guifg=NONE ctermfg=NONE
  autocmd VimEnter * highlight NERDTreeLinkFile guifg=NONE ctermfg=magenta
  autocmd VimEnter * highlight NERDTreeExecFile guifg=NONE ctermfg=red
end

" shortcut to rapidly toggle `set list`
nmap <silent> <Leader>li :set list!<CR>
set listchars=tab:▸\ ,eol:¬,nbsp:¶

" Colors!
highlight Comment ctermfg=blue

" invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" highlight the 80th column
"highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
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

" Turn cursorline on only while a search command line is open, so the
" cursor stays easy to spot while typing a pattern, then put the option
" back the way it was.
if exists('##CmdlineEnter')
  function! <SID>SearchCursorLineOn()
    let s:cursorline_before = &cursorline
    set cursorline
    redraw
  endfunction

  function! <SID>SearchCursorLineOff()
    if exists('s:cursorline_before')
      let &cursorline = s:cursorline_before
      unlet s:cursorline_before
    endif
  endfunction

  augroup SearchCursorLine
    autocmd!
    autocmd CmdlineEnter /,\? call <SID>SearchCursorLineOn()
    autocmd CmdlineLeave /,\? call <SID>SearchCursorLineOff()
  augroup END
endif

" Function to disable syntax highlighting based on 'maxmempattern'
function! DisableSyntaxBasedOnPatternMemory()
    " Retrieve 'maxmempattern' value (in KB)
    let max_pat_mem_kb = &maxmempattern

    " Define a multiplier to set file size threshold.
    let multiplier = 512  " Adjust as needed

    " Calculate file-size threshold (heuristic scaling, not an exact
    " KB-to-byte conversion)
    let threshold = max_pat_mem_kb * multiplier

    " Get the current file size in bytes
    let file_size = getfsize(expand("%"))

    " Ensure file_size is valid
    if file_size == -1
        return
    endif

    " Check if file size exceeds the threshold
    if file_size > threshold
        syntax off
        echo "Syntax highlighting disabled for large file (" . printf("%.2f KB", file_size / 1024) . ")."
    endif
endfunction

" Automatically call the function before reading a buffer
autocmd BufReadPre * call DisableSyntaxBasedOnPatternMemory()
