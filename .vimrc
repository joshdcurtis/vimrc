let mapleader=','

" PLUGINS "
call plug#begin('~/.vim/plugged') " Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)

" FEATURES "
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " traverse file tree
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'junegunn/goyo.vim' " no distractions
Plug 'tpope/vim-fugitive' " git tools
Plug 'sjl/gundo.vim' " tree-like undo mapped to <F5> below
Plug 'Raimondi/delimitMate' " auto-close parens/braces/etc.
Plug 'scrooloose/nerdcommenter' " Commenting features
Plug 'altercation/vim-colors-solarized' " Solarized colorscheme
Plug 'vim-airline/vim-airline' " airline bar
Plug 'vim-airline/vim-airline-themes' " themes for airline
Plug 'ervandew/supertab' " tab completion

" LANGUAGES "
"Plug 'artur-shaik/vim-javacomplete2' " Java autocomplete
Plug 'vim-jp/vim-cpp' " c/c++
Plug 'elzr/vim-json' " JSON
Plug 'pangloss/vim-javascript' " javascript
Plug 'Quramy/tsuquyomi' " typescript IDE???
Plug 'leafgarland/typescript-vim' " typescript
Plug 'mxw/vim-jsx' " JSX

call plug#end() " Initialize plugin system

filetype plugin indent on " check filetype
syntax enable " enable syntax processing

" PLUGIN CONFIGURATIONS "
" airline
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '>'

let g:airline#extensions#tabline#enabled = 1 " starts with tabline

" ITERM PROFILE SPECIFICITIES "
let iterm_profile = $ITERM_PROFILE
if iterm_profile == "Solarized Dark"
  set background=dark
  colorscheme solarized
  let g:airline_theme='solarized'
  let g:airline_solarized_bg='dark'
elseif iterm_profile == "Solarized Light"
  set background=light
  colorscheme solarized
  let g:airline_theme='solarized'
  let g:airline_solarized_bg='light'
else
  colorscheme torte
  highlight LineNr ctermfg=grey
endif

set shiftwidth=2 " number of spaces for an indentation level
set tabstop=2 " number of visual spaces per TAB
set softtabstop=2 " number of spaces in tab when editing
set expandtab " TABs are spaces

" Syntax of these languages is fussy over tabs Vs spaces
autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Customisations based on house-style (arbitrary)
autocmd FileType c setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType java setlocal ts=4 sts=4 sw=4 expandtab

" UI Config "
set ruler " show line/column in bottom right
set number " show line numbers
set showcmd " show command in the bottom bar
set cursorline " highlight current line
set laststatus=2 " display the status line at all times

set wildmenu " visual autocomplete for command menu
set lazyredraw " redraw only when we need to
set showmatch " highlight matching [{()}]

" SEARCH "
set incsearch " search as characters are entered
set hlsearch " highlight matches
" turn off search highlighting with ',l'
nnoremap <leader><CR> :nohlsearch<CR>

" MOVEMENT "
" move vertically by visual line
nnoremap j gj
nnoremap k gk
" move to beginning or end of line
nnoremap B ^
nnoremap E $
" highlight last inserted text
nnoremap gV `[v`]

" ESCAPING "
inoremap jj <Esc>`^

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

" F KEY BINDINGS "
nnoremap <F5> :GundoToggle<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <F8> :Goyo<CR>

" FUNCTIONS "
" executes some command without changing cursor or search pattern
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
nnoremap _$ :call Preserve("%s/\\s\\+$//e")<CR>
nnoremap _= :call Preserve("normal gg=G")<CR>

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction
