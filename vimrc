call plug#begin('~/.vim/plugged')

" Base plugins
Plug 'tpope/vim-commentary'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'bkad/CamelCaseMotion'
Plug 'tpope/vim-endwise'
Plug 'andymass/vim-matchup'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-projectionist'
Plug 'windwp/nvim-autopairs'
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'mg979/vim-visual-multi'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-repeat'
Plug 'dietsche/vim-lastplace'
Plug 'ntpeters/vim-better-whitespace'
Plug 'nvim-lualine/lualine.nvim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-grepper'
Plug 'mbbill/undotree'
Plug 'yssl/QFEnter'
Plug 'ludovicchabant/vim-gutentags'
Plug 'jpalardy/vim-slime'

if has('nvim')
  Plug 'neovim/nvim-lspconfig'

  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-omni'
endif

Plug 'sheerun/vim-polyglot'
Plug 'yasuhiroki/github-actions-yaml.vim'

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
let $LANG='en_US.UTF-8'

nnoremap <silent> <BS> :nohlsearch<CR>
set inccommand=split

" Quick local search & replace
nnoremap R :%s/\V<C-R><C-W>//g<LEFT><LEFT>
vnoremap R "sy <bar> :%s/\V<C-R>s//g<LEFT><LEFT>

nnoremap <leader>r :call <SID>Refs(expand('<cword>'))<CR>
vnoremap <leader>r "sy <bar> :Ag -w '<C-R>s'<CR>

function! s:Refs(word)
  execute 'Ag -w ' . a:word
endfunction

"indent settings
set shiftwidth=2
set softtabstop=2
set expandtab

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

set background=dark
colorscheme gruvbox

" Move between open buffers
nnoremap gr :bn<CR>
nnoremap gR :bp<CR>

" Soft wrap in quickfix
augroup quickfix
    autocmd!
    autocmd FileType qf setlocal wrap
augroup END

nnoremap <silent> <Leader>p :NvimTreeToggle<CR>
nnoremap <silent> <C-f> :NvimTreeFindFile<CR>
nnoremap <silent> <Leader>u :UndotreeToggle<CR>

" Comment toggle
nmap <leader>cc gcc
xmap <leader>cc gc

"make Y consistent with C and D
nnoremap Y y$

if has('persistent_undo')
  set undolevels=5000
  set undodir=$HOME/.vim_undo
  set undofile
endif

" Completion
set completeopt+=menuone
set completeopt+=noselect
set shortmess+=c
set omnifunc=syntaxcomplete#Complete
" Disable weird autocomplete for SQL
let g:omni_sql_no_default_maps = 1
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:omni_sql_default_compl_type = 'syntax'

if has('nvim')
  lua require('diagnostic')
  lua require('lsp')
  lua require('cmp_conf')
  lua require('nvim_tree')
  lua require('autopairs')
  lua require('lualine_conf')
endif

let g:matchup_matchparen_deferred = 1

let g:ragtag_global_maps = 1

let g:gutentags_ctags_executable_ruby = 'ripper-tags'
let g:gutentags_file_list_command = {
      \ 'markers': {
      \ '.git': 'bash -c "git ls-files; git ls-files --others --exclude-standard"',
      \ },
      \ }

function! InsertPathSink(arg)
  if empty(a:arg)
    return
  endif

  let list = type(a:arg) == type([]) ? a:arg : split(a:arg, "\n")
  let paths = join(list, ' ')

  if empty(paths)
    return
  endif

  let line = line('.')
  let col = col('.')

  if getline(line)[col-1] == '@'
    let old_line = getline(line)
    let new_line = strpart(old_line, 0, col) . paths . strpart(old_line, col)
    call setline(line, new_line)
    call cursor(line, col + len(paths))
  else
    if getline('.')[col('.')-1] =~ '\a'
      normal! e
    endif
    execute 'normal! a ' . paths . ' '
  endif
  startinsert!
endfunction

command! FzfInsertPath call fzf#vim#files('', {'sink': function('InsertPathSink'), 'options': '--multi', 'window': { 'width': 0.8, 'height': 0.6 }})

"map for FZF
map <leader>t :Files<CR>
map <leader>b :Buffers<CR>
map <leader>z :Mz<CR>
map <leader>m :FzfInsertPath<CR>

map <leader>d :Mt<CR>


function! s:Rename(args)
  execute 'Reruby rename_const ' . a:args
endfunction

command! -nargs=* Rnm :call <SID>Rename(expand('<args>'))

augroup ruby_autocommands
  autocmd!
  " For big files syntax folding is slow, disable it for known problematic ones
  autocmd BufRead,BufNewFile */config/routes.rb setlocal foldmethod=manual
  autocmd BufRead,BufNewFile */schema.rb setlocal foldmethod=manual
augroup END

augroup other_autocommands
  autocmd!
  autocmd BufWritePre * StripWhitespace
  autocmd BufNewFile,BufRead Dockerfile.* set filetype=dockerfile
  autocmd BufNewFile,BufRead */gemini-edit-*/buffer.txt set filetype=markdown
  autocmd BufNewFile,BufRead */gemini-edit-*/buffer.txt inoremap <buffer> @ @<C-o>:FzfInsertPath<CR>
  autocmd BufNewFile,BufRead myprompts/*.md inoremap <buffer> @ @<C-o>:FzfInsertPath<CR>
  autocmd BufNewFile,BufRead claude-prompt-*.md inoremap <buffer> @ @<C-o>:FzfInsertPath<CR>
augroup END

"vim-test
let test#strategy = "dispatch"
let test#ruby#rspec#options = "--no-color"

"Old school Ag
command! -nargs=+ -complete=file Ag Grepper -noprompt -tool ag -query --hidden --ignore .git <args>

"QFEnter
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']

" slime
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
let g:slime_dont_ask_default = 1

set backspace=indent,eol,start
set nomodelineexpr

nnoremap <silent> Q gqip
vnoremap <silent> Q gq

function! s:MarkdownCopy(operateOn)
  let winSave = winsaveview()
  let oldTw=&tw
  set tw=9999
  silent execute a:operateOn . 'call <SID>ReformatMarkdown()'
  silent execute a:operateOn . 'y +'
  silent normal u
  let &tw=oldTw
  call winrestview(winSave)
endfunction

function! s:ReformatMarkdownParagraph()
  let isCurrentFence = getline('.') =~ '^ *```'

  if isCurrentFence
    let b:inFencedCodeBlock = !b:inFencedCodeBlock
  elseif !b:inFencedCodeBlock
    " execute 'normal i' . b:inFencedCodeBlock
    normal gqip
  endif
endfunction

function! s:ReformatMarkdown() range
  let winSave = winsaveview()
  let b:inFencedCodeBlock = 0
  let comments_snapshot = &comments
  setlocal comments=fb:*,fb:-,fb:+,n:>,fb:\|,s:```,e:```
  redir END

  call cursor(a:firstline, 1)
  call s:ReformatMarkdownParagraph()
  while line('.') < a:lastline && line('.') < line('$')
    normal j
    call <SID>ReformatMarkdownParagraph()
  endwhile

  unlet b:inFencedCodeBlock
  call winrestview(winSave)
  let &l:comments = comments_snapshot
endfunction

augroup markdown_autocommands
  autocmd!
  " Don't wrap text on gh PR body
  autocmd BufRead,BufNewFile /tmp/*.md setlocal tw=9999
  autocmd BufRead,BufNewFile /private/var/folders*.md setlocal tw=9999

  " Spanish spelling by filename
  autocmd BufRead,BufNewFile *.es.md setlocal spelllang=es

  autocmd FileType markdown setlocal indentexpr=
  autocmd FileType markdown setlocal spell
  autocmd FileType markdown setlocal tabstop=2
  autocmd FileType markdown setlocal softtabstop=2
  autocmd FileType markdown setlocal shiftwidth=2
  autocmd FileType markdown nnoremap <silent> Q :.call <SID>ReformatMarkdown()<CR>
  autocmd FileType markdown vnoremap <silent> Q :'<'>call <SID>ReformatMarkdown()<CR>
  autocmd FileType markdown nnoremap <silent> <leader>cy :silent call <SID>MarkdownCopy('%')<CR>
  autocmd FileType markdown vnoremap <silent> <leader>cy :<C-U>silent call <SID>MarkdownCopy("'<,'>")<CR>
augroup END

command! Mt Mg '[-\*] *\[' *\*]'


set exrc

set secure
