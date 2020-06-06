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
Plug 'Konfekt/FastFold'

" Issue with latest polyglot, js not highlighted in tsx/jsx
" Check back if it can be removed
let g:polyglot_disabled = ['jsx']
Plug 'maxmellon/vim-jsx-pretty'

Plug 'sheerun/vim-polyglot'

"SCM
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-rhubarb'

"Js, HTML...
Plug 'tpope/vim-ragtag'

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
Plug 'dgsuarez/vim-checka-wah-wah'

call plug#end()            " required

set number
set visualbell t_vb=
let mapleader = "ñ"

set hlsearch
nnoremap <silent> <BS> :nohlsearch<CR>
if exists('&inccommand')
  set inccommand=split
endif

" Quick local search & replace
nnoremap R :%s/\V<C-R><C-W>//g<LEFT><LEFT>
vnoremap R "sy <bar> :%s/\V<C-R>s//g<LEFT><LEFT>

" Poor man's usage finder with Ag
command! -nargs=* Refs Ag <cword> -w <args>
nnoremap <leader>r :Refs<CR>
vnoremap <leader>r "sy <bar> :Ag -w '<C-R>s'<CR>

"statusline setup
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_section_a = ''
let g:airline_section_b='%{fugitive#statusline()}'
let g:airline#extensions#tabline#enabled = 1

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
let g:markdown_folding = 1
nnoremap zz za

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
  colorscheme monochrome
endif

" Move between open buffers
nnoremap gr :bn<CR>
nnoremap gR :bp<CR>

let g:nerdtree_tabs_open_on_gui_startup = 0

nnoremap <silent> <Leader>p :NERDTreeToggle<CR>
nnoremap <silent> <C-f> :NERDTreeFind<CR>
nnoremap <silent> <Leader>u :UndotreeToggle<CR>

" Add space after comment symbol
let NERDSpaceDelims=1
map <leader>a <plug>NERDCommenterToggle

"make Y consistent with C and D
nnoremap Y y$

if has('persistent_undo')
  set undolevels=5000
  set undodir=$HOME/.vim_undo
  set undofile
endif

let g:matchup_matchparen_deferred = 1

let g:ragtag_global_maps = 1

let g:gutentags_define_advanced_commands = 1
let g:gutentags_ctags_executable_ruby = '~/.vim/rtags'

"map for FZF
map <leader>t :Files<CR>
map <leader>b :Buffers<CR>
map <leader>z :Mz<CR>


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
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact nmap <buffer> <leader>i :YcmCompleter GetType<CR>
augroup END

augroup ruby_autocommands
  autocmd!
  " For big files syntax folding is slow, disable it for known problematic ones
  autocmd BufRead,BufNewFile */config/routes.rb setlocal foldmethod=manual
  autocmd BufRead,BufNewFile */schema.rb setlocal foldmethod=manual
  " Shorter reruby rename
  autocmd FileType ruby command! -nargs=* Rnm Reruby rename_const <args>
augroup END

augroup markdown_autocommands
  autocmd!
  autocmd FileType markdown setlocal spell
  autocmd FileType markdown let b:ale_fixers = ['prettier', 'remove_trailing_lines', 'trim_whitespace']
  autocmd FileType markdown let b:ale_javascript_prettier_options = '--prose-wrap always'
  autocmd FileType markdown let b:ale_fix_on_save = 1
augroup END

augroup other_autocommands
  autocmd!
  autocmd BufWritePre * StripWhitespace
  autocmd BufNewFile,BufRead Dockerfile.* set filetype=dockerfile
augroup END

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

nnoremap <silent> Q gqip
vnoremap <silent> Q gq

function! s:WithProseFormat(operation)
  let oldComments=&comments

  set comments=fb:*,fb:-,fb:+,n:>

  silent execute a:operation

  let &comments=oldComments
endfunction

function! s:MarkdownCopy(operateOn)
  let winSave = winsaveview()
  let oldTw=&tw
  set tw=9999
  call s:WithProseFormat(a:operateOn . 'g/^/normal gqip')
  silent execute a:operateOn . 'y +'
  silent normal u
  let &tw=oldTw
  call winrestview(winSave)
endfunction

augroup markdown_copy_autocommands
  autocmd!
  autocmd FileType markdown nnoremap <silent> Q :silent call <SID>WithProseFormat('.g/^/normal gqip')<CR>
  autocmd FileType markdown vnoremap <silent> Q :<C-U>silent call <SID>WithProseFormat("'<,'>g/^/normal gqip")<CR>
  autocmd FileType markdown nnoremap <silent> <leader>c :silent call <SID>MarkdownCopy('%')<CR>
  autocmd FileType markdown vnoremap <silent> <leader>c :<C-U>silent call <SID>MarkdownCopy("'<,'>")<CR>
augroup END


function! g:BetterGoToTag(tag, referenceFile)
  let tagIndex=1
  let bestScore = 0
  let bestTagIndex = tagIndex

  for entry in taglist('^' . a:tag . '$')
    let score = g:ScoreCandidate(entry['filename'], a:referenceFile)
    if score > bestScore
      let bestTagIndex = tagIndex
      let bestScore = score
    endif
    let tagIndex += 1
  endfor

  execute bestTagIndex . 'tag ' . a:tag
endfunction

function! g:ScoreCandidate(candidateFile, referenceFile)
  if(a:candidateFile == a:referenceFile)
    return 1000
  endif

  let referenceFileParts = g:GetFileParts(a:referenceFile)
  let candidateFileParts = g:GetFileParts(a:candidateFile)

  let score=0

  for part in candidateFileParts
    if index(referenceFileParts, part) > 0
      let score +=1
    endif
  endfor

  return score
endfunction

function! g:GetFileParts(file)
  return reverse(split(fnamemodify(a:file, ':r'), '/'))
endfunction

nnoremap <silent> <C-]> :call g:BetterGoToTag(expand('<cword>'), expand('%'))<CR>
vnoremap <silent> <C-]> "sy <bar> :call g:BetterGoToTag('<C-R>s', expand('%'))<CR>

set exrc

set secure
