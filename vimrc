"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

call plug#begin('~/.vim/plugged')

" Base plugins
Plug 'tpope/vim-sensible'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'kien/ctrlp.vim'
Plug 'burke/matcher', { 'do': 'make' }
Plug 'mileszs/ack.vim'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'bkad/CamelCaseMotion'
Plug 'tpope/vim-endwise'
Plug 'sjl/gundo.vim'
Plug 'edsono/vim-matchit'
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }
Plug 'ciaranm/securemodelines'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-surround'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-projectionist'
Plug 'Townk/vim-autoclose'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-repeat'

"SCM
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'dgsuarez/thermometer'

"Js, HTML...
Plug 'lukaszb/vim-web-indent'
Plug 'jelera/vim-javascript-syntax'
Plug 'nono/vim-handlebars'
Plug 'cakebaker/scss-syntax.vim'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-markdown'

"Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rvm'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-bundler'
Plug 'kana/vim-textobj-user'
Plug 'tek/vim-textobj-ruby'
Plug 'ngmy/vim-rubocop'

"Clojure
Plug 'vim-scripts/paredit.vim', {'for': 'clojure'}
Plug 'tpope/vim-classpath', {'for': 'clojure'}
Plug 'guns/vim-clojure-static', {'for': 'clojure'}
Plug 'tpope/vim-fireplace', {'for': 'clojure'}

"Misc
Plug 'greyblake/vim-preview'
Plug 'dgsuarez/vim-ticard'

call plug#end()            " required

set number
set visualbell t_vb=
set hlsearch
"statusline setup
set statusline=%f       "tail of the filename

"Syntastic

set statusline+=%#warningmsg#
set statusline+=\%{SyntasticStatuslineFlag()}
set statusline+=%*

"SCM

set statusline+=%{g:HgStatusLine()}
set statusline+=%{fugitive#statusline()}

"RVM
set statusline+=%{exists('g:loaded_rvm')?rvm#statusline():''}

set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2

"turn off needless toolbar on gvim/mvim
set guioptions-=T

"indent settings
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

"vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

"load ftplugins and indent files
filetype plugin on
filetype indent on

"turn on syntax highlighting
syntax on

"some stuff to get the mouse going in term
set mouse=a
set ttymouse=xterm2

"hide buffers when not displayed
set hidden

if match($TERM, "256") != -1
  set background=dark
  colorscheme solarized
else
  colorscheme default
endif


let g:buffergator_suppress_keymaps = 1
let g:nerdtree_tabs_open_on_gui_startup = 0

 let g:PreviewBrowsers='google-chrome,firefox'

silent! nmap <silent> <Leader>b :BuffergatorToggle<CR>
silent! nmap <silent> <Leader>p :NERDTreeTabsToggle<CR>
nnoremap <silent> <C-f> :NERDTreeTabsOpen<CR> :NERDTreeTabsFind<CR>

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc



"make Y consistent with C and D
nnoremap Y y$

let g:ragtag_global_maps = 1

"mark syntax errors with :signs
let g:syntastic_enable_signs=1

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction

"CtrlP

let g:ctrlp_custom_ignore = '\v.*\/vendor\/.*'

let g:path_to_matcher = "~/.vim/plugged/matcher/matcher"

if !empty(glob(g:path_to_matcher))
  let g:ctrlp_match_func = { 'match': 'GoodMatch' }
endif

function! GoodMatch(items, str, limit, mmode, ispath, crfile, regex)

  " Create a cache file if not yet exists
  let cachefile = ctrlp#utils#cachedir().'/matcher.cache'
  if !( filereadable(cachefile) && a:items == readfile(cachefile) )
    call writefile(a:items, cachefile)
  endif
  if !filereadable(cachefile)
    return []
  endif

  " a:mmode is currently ignored. In the future, we should probably do
  " something about that. the matcher behaves like "full-line".
  let cmd = g:path_to_matcher.' --limit '.a:limit.' --manifest '.cachefile.' '
  if !( exists('g:ctrlp_dotfiles') && g:ctrlp_dotfiles )
    let cmd = cmd.'--no-dotfiles '
  endif
  let cmd = cmd.a:str

  return split(system(cmd), "\n")

endfunction

let g:ctrlp_match_window_bottom=0
let g:ctrlp_match_window_reversed = 0

"map for ctrl-p
map <leader>t :CtrlP<CR>

"map for gundo
map <Leader>g :GundoToggle<CR>

"key mapping for window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l


au BufNewFile,BufRead *.prawn set filetype=ruby
let g:AutoCloseExpandEnterOn = ""

"options for markdown files
au BufNewFile,BufRead *.md set tw=78 formatoptions=t1 filetype=markdown spell

noremap Q gqap

:imap jj <Esc>

set pastetoggle=<F7>
