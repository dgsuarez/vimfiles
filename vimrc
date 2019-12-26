"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

call plug#begin('~/.vim/plugged')

" Base plugins
Plug 'tpope/vim-sensible'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'bkad/CamelCaseMotion'
Plug 'tpope/vim-endwise'
Plug 'tmhedberg/matchit'
Plug 'ciaranm/securemodelines'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-projectionist'
Plug 'Raimondi/delimitMate'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-repeat'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'dietsche/vim-lastplace'
Plug 'fxn/vim-monochrome'
Plug 'ntpeters/vim-better-whitespace'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-grepper'
Plug 'w0rp/ale'
Plug 'mbbill/undotree'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --ts-completer' }
Plug 'yssl/QFEnter'

Plug 'sheerun/vim-polyglot'

"SCM
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'dgsuarez/thermometer'
Plug 'whiteinge/diffconflicts'

"Js, HTML...
Plug 'pangloss/vim-javascript'
Plug 'nono/vim-handlebars'
Plug 'cakebaker/scss-syntax.vim'
Plug 'tpope/vim-ragtag'
Plug 'godlygeek/tabular'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'digitaltoad/vim-pug'
Plug 'kchmck/vim-coffee-script'

"Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-bundler'
Plug 'kana/vim-textobj-user'
Plug 'tek/vim-textobj-ruby'
Plug 'janko-m/vim-test'
Plug 'dgsuarez/reruby.vim'
Plug 'slim-template/vim-slim'

"Other langs
Plug 'rhysd/vim-crystal'
Plug 'elixir-lang/vim-elixir'
Plug 'tpope/vim-dadbod'

"Misc
Plug 'dgsuarez/vim-ticard'
Plug 'dgsuarez/vim-codeshot'
Plug 'simplenote-vim/simplenote.vim'

call plug#end()            " required

set number
set visualbell t_vb=
set hlsearch
let mapleader = "ñ"


if exists('&inccommand')
  set inccommand=split
endif

"statusline setup
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

"SCM

function! ScmAirline()
  let hg = g:HgStatusLine()
  if hg == ""
    return fugitive#statusline()
  else
    return hg
  end
endfunction

let g:airline_section_a = ''
let g:airline_section_b='%{ScmAirline()}'

set laststatus=2

"turn off needless toolbar on gvim/mvim
set guioptions-=T

"indent settings
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

"folding settings
set foldmethod=syntax   "fold based on syntax
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" For big files syntax folding is slow, disable it for known problematic ones
autocmd BufRead,BufNewFile */config/routes.rb setlocal foldmethod=manual
autocmd BufRead,BufNewFile */schema.rb setlocal foldmethod=manual

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

"hide buffers when not displayed
set hidden

if match($TERM, "256") != -1
  set background=dark
  colorscheme solarized
else
  colorscheme default
endif


let g:airline#extensions#tabline#enabled = 1

" Move between open buffers
nnoremap gr :bn<CR>
nnoremap gR :bp<CR>

let g:nerdtree_tabs_open_on_gui_startup = 0

silent! nmap <silent> <Leader>p :NERDTreeToggle<CR>
nnoremap <silent> <C-f> :NERDTreeFind<CR>
silent! nmap <silent> <Leader>u :UndotreeToggle<CR>

" Add space after comment symbol
let NERDSpaceDelims=1

"make Y consistent with C and D
nnoremap Y y$

let g:ragtag_global_maps = 1


"map for FZF
map <leader>t :Files<CR>
map <leader>b :Buffers<CR>

"maps for YCM GoTo
let g:ycm_key_detailed_diagnostics=''
map <leader>g :YcmCompleter GoTo<CR>
map <leader>d :YcmCompleter GetDoc<CR>

"vim-test
let test#strategy = "dispatch"
let test#ruby#use_spring_binstub = 1

"Old school Ag
command! -nargs=+ -complete=file Ag Grepper -noprompt -tool ag -query <args>

"QFEnter
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']

"whitespace
autocmd BufWritePre * StripWhitespace

"ale
let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_lint_on_text_changed = 'never'
let g:ale_fixers = {
\   'ruby': ['rubocop'],
\   'javascript': ['eslint'],
\}


"key mapping for window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

au BufNewFile,BufRead *.prawn set filetype=ruby
au BufNewFile,BufRead Dockerfile.* set filetype=dockerfile
let g:AutoCloseExpandEnterOn = ""

noremap Q gqap

let g:pandoc#syntax#conceal#use = 0
let g:pandoc#formatting#mode = 'ha'
let g:pandoc#modules#disabled = ["chdir"]

set pastetoggle=<F7>
nnoremap <F5> :checktime<cr>

let g:SimplenoteUsername = $SIMPLE_NOTE_USERNAME
let g:SimplenotePassword = $SIMPLE_NOTE_PASSWORD

set exrc

set secure
