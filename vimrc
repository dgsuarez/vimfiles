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
Plug 'andymass/vim-matchup'
Plug 'ciaranm/securemodelines'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-projectionist'
Plug 'jiangmiao/auto-pairs'
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
Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 install.py --ts-completer' }
Plug 'yssl/QFEnter'
Plug 'ludovicchabant/vim-gutentags'

Plug 'sheerun/vim-polyglot'

"SCM
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-rhubarb'
Plug 'dgsuarez/thermometer'

"Js, HTML...
Plug 'tpope/vim-ragtag'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

"Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-bundler'
Plug 'kana/vim-textobj-user'
Plug 'tek/vim-textobj-ruby'
Plug 'janko-m/vim-test'
Plug 'dgsuarez/reruby.vim'

"Other langs
Plug 'tpope/vim-dadbod'

"Misc
Plug 'dgsuarez/vim-ticard'
Plug 'dgsuarez/vim-codeshot'
Plug 'dgsuarez/vim-mootes'

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
map <leader>a <plug>NERDCommenterToggle

"make Y consistent with C and D
nnoremap Y y$

let g:ragtag_global_maps = 1

let g:gutentags_define_advanced_commands = 1
let g:gutentags_ctags_executable_ruby = '~/.vim/rtags'

"map for FZF
map <leader>t :Files<CR>
map <leader>b :Buffers<CR>

"YCM conf
let g:ycm_key_detailed_diagnostics=''

function! Multiple_cursors_before()
  let s:old_ycm_whitelist = g:ycm_filetype_whitelist
  let g:ycm_filetype_whitelist = {}
  ALEDisable
endfunction

function! Multiple_cursors_after()
  let g:ycm_filetype_whitelist = s:old_ycm_whitelist
  ALEEnable
endfunction

augroup js_autocommands
  autocmd!
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact nmap <buffer> <C-]> :YcmCompleter GoTo<CR>
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact command! -nargs=0 Refs YcmCompleter GoToReferences
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact command! -nargs=* Rnm YcmCompleter RefactorRename <args>
augroup END

augroup ruby_autocommands
  autocmd!
  " For big files syntax folding is slow, disable it for known problematic ones
  autocmd BufRead,BufNewFile */config/routes.rb setlocal foldmethod=manual
  autocmd BufRead,BufNewFile */schema.rb setlocal foldmethod=manual
  " Shorter reruby rename
  autocmd FileType ruby command! -nargs=* Rnm Reruby rename_const <args>
augroup END

augroup other_autocommands
  autocmd!
  autocmd BufWritePre * StripWhitespace
  autocmd BufNewFile,BufRead Dockerfile.* set filetype=dockerfile
augroup END

" Poor man's usage finder with Ag
command! -nargs=* Refs Ag <cword> -w <args>
map <leader>r :Refs<CR>


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


"ale
let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_fixers = {
\   'ruby': ['rubocop'],
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'javascriptreact': ['prettier'],
\   'typescriptreact': ['prettier'],
\}

let g:AutoCloseExpandEnterOn = ""

noremap Q gqap

let g:pandoc#syntax#conceal#use = 0
let g:pandoc#formatting#mode = 'ha'
let g:pandoc#modules#disabled = ["chdir"]

set pastetoggle=<F7>
nnoremap <F5> :checktime<cr>

map <leader>m :M<CR>
map <leader>z :Mz<CR>

set exrc

set secure
