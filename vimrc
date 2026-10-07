" Shared by Vim and Neovim. Plain Vim stops at the `finish` below and runs plugin-less.

let mapleader = "ñ"

set number
set visualbell t_vb=
let $LANG='en_US.UTF-8'

nnoremap <silent> <BS> :nohlsearch<CR>

" Quick local search & replace
nnoremap R :%s/\V<C-R><C-W>//g<LEFT><LEFT>
xnoremap R "sy <bar> :%s/\V<C-R>s//g<LEFT><LEFT>

"indent settings
set shiftwidth=2
set softtabstop=2
set expandtab

"folding settings
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default
nnoremap zz za

set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

"vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

set background=dark

" Soft wrap in quickfix
augroup quickfix
    autocmd!
    autocmd FileType qf setlocal wrap
augroup END

" Navigation (ç = next, ´ = previous)
nnoremap <silent> çb :bn<CR>
nnoremap <silent> ´b :bp<CR>
nnoremap <silent> çq :cnext<CR>
nnoremap <silent> ´q :cprev<CR>

"make Y consistent with C and D
nnoremap Y y$

if has('persistent_undo')
  set undolevels=5000
  " Vim and Neovim undo files are incompatible, keep them apart
  if has('nvim')
    set undodir=$HOME/.vim_undo
  else
    set undodir=$HOME/.vim_undo_vim
    silent! call mkdir(&undodir, 'p')
  endif
  set undofile
endif

" Completion
set completeopt+=menuone
set completeopt+=noselect
set shortmess+=c
let g:loaded_sql_completion = 1

augroup ruby_autocommands
  autocmd!
  " Computing folds on these huge files is slow
  autocmd BufRead,BufNewFile */config/routes.rb setlocal foldmethod=manual
  autocmd BufRead,BufNewFile */schema.rb setlocal foldmethod=manual
augroup END

augroup other_autocommands
  autocmd!
  autocmd BufNewFile,BufRead Dockerfile.* set filetype=dockerfile
  autocmd BufNewFile,BufRead */gemini-edit-*/buffer.txt set filetype=markdown
augroup END

set nomodelineexpr

nnoremap <silent> Q gqip
xnoremap <silent> Q gq

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
  autocmd BufRead,BufNewFile /tmp/claude-prompt-*.md setlocal tw<
  autocmd BufRead,BufNewFile /private/var/folders*.md setlocal tw=9999
  autocmd BufRead,BufNewFile /private/var/folders*/claude-prompt-*.md setlocal tw<

  " Spanish spelling by filename
  autocmd BufRead,BufNewFile *.es.md setlocal spelllang=es

  autocmd FileType markdown setlocal indentexpr=
  autocmd FileType markdown setlocal spell
  autocmd FileType markdown setlocal tabstop=2
  autocmd FileType markdown setlocal softtabstop=2
  autocmd FileType markdown setlocal shiftwidth=2
  autocmd FileType markdown nnoremap <buffer> <silent> Q :.call <SID>ReformatMarkdown()<CR>
  autocmd FileType markdown xnoremap <buffer> <silent> Q :'<'>call <SID>ReformatMarkdown()<CR>
  autocmd FileType markdown nnoremap <buffer> <silent> <leader>cy :silent call <SID>MarkdownCopy('%')<CR>
  autocmd FileType markdown xnoremap <buffer> <silent> <leader>cy :<C-U>silent call <SID>MarkdownCopy("'<,'>")<CR>
augroup END

set exrc

set secure

if !has('nvim')
  filetype plugin indent on
  syntax enable
  silent! colorscheme habamax
  finish
endif

" Neovim only from here on.

" :X is reserved for encryption in Vim
command! X w | bd

" vim-ruby probes has('ruby') on every Ruby buffer, which is slow; the host isn't installed anyway
let g:loaded_ruby_provider = 0
" vim-rails turns this on, making vim-ruby shell out to ruby to build 'path' for stdlib gf
let g:ruby_exec = 0

" Plugin globals, read when the plugins load
let g:matchup_matchparen_deferred = 1

let g:ragtag_global_maps = 1

let g:gutentags_ctags_executable_ruby = 'ripper-tags'
let g:gutentags_file_list_command = {
      \ 'markers': {
      \ '.git': 'bash -c "git ls-files; git ls-files --others --exclude-standard"',
      \ },
      \ }

"vim-test
let test#strategy = "dispatch"
let test#ruby#rspec#options = "--no-color"

"QFEnter
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']

" slime
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
let g:slime_dont_ask_default = 1

" nvim-tree replaces netrw, and netrw must be off before any plugin loads
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

lua require('config.lazy')

set inccommand=split

set foldmethod=expr     "fold based on treesitter
set foldexpr=v:lua.vim.treesitter.foldexpr()

colorscheme gruvbox

nnoremap <leader>r :call <SID>Refs(expand('<cword>'))<CR>
xnoremap <leader>r "sy <bar> :Ag -w '<C-R>s'<CR>

function! s:Refs(word)
  execute 'Ag -w ' . a:word
endfunction

nnoremap <silent> <Leader>p :NvimTreeToggle<CR>
nnoremap <silent> <C-f> :NvimTreeFindFile<CR>
nnoremap <silent> <Leader>u :UndotreeToggle<CR>

" Comment toggle
nmap <leader>cc gcc
xmap <leader>cc gc

" Start a named server socket so nvim-remote-edit can send files here
if exists('$TMUX')
  let s:session = trim(system('tmux display-message -p "#S"'))
  silent! call serverstart('/tmp/nvim-' . s:session . '.sock')
endif

lua require('diagnostic')
lua require('lsp')
lua require('lualine_conf')
lua require('treesitter')

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
    call cursor(line, col + len(paths) + 1)
  else
    if getline('.')[col('.')-1] =~ '\a'
      normal! e
    endif
    execute 'normal! a ' . paths . ' '
  endif
  call feedkeys('a', 'n')
endfunction

" fzf opens files in the current window, which may be quickfix, nvim-tree, trouble...
function! s:FocusEditableWindow()
  if empty(&buftype)
    return
  endif
  for w in [winnr('#')] + range(1, winnr('$'))
    if w > 0 && empty(getbufvar(winbufnr(w), '&buftype'))
      execute w . 'wincmd w'
      return
    endif
  endfor
endfunction

function! UnifiedFzf(mode, ...)
  " Path insertion (a:1 sink) targets the buffer being typed in, so only move for opening files
  if a:0 == 0
    call s:FocusEditableWindow()
  endif
  let filecmd = $FZF_DEFAULT_COMMAND
  let bufs = getbufinfo({'buflisted': 1})
  let cur = bufnr('%')
  call filter(bufs, {_, b -> !empty(b.name) && b.bufnr != cur})
  call sort(bufs, {a, b -> b.lastused - a.lastused})
  let curbuf = empty(bufname(cur)) ? [] : [shellescape(fnamemodify(bufname(cur), ':~:.'))]
  let bufcmd = "printf '%s\\n' " . join(map(bufs, {_, b -> shellescape(fnamemodify(b.name, ':~:.'))}) + curbuf, ' ')

  if a:mode ==# 'buffers'
    let source = bufcmd
    let prompt = 'Buf> '
  else
    let source = filecmd
    let prompt = 'Files> '
  endif

  let toggle = 'ctrl-s:transform:if [[ $FZF_PROMPT == "Files> " ]]; then'
    \ . ' echo "reload(' . bufcmd . ')+change-prompt(Buf> )";'
    \ . ' else echo "reload(' . filecmd . ')+change-prompt(Files> )"; fi'

  let spec = {
    \ 'source': source,
    \ 'options': ['--multi', '--prompt', prompt,
    \   '--header', 'ctrl-s: toggle files/buffers',
    \   '--bind', toggle],
    \ }

  if a:0 > 0
    let spec.sink = a:1
  endif

  call fzf#run(fzf#wrap(fzf#vim#with_preview(spec)))
endfunction

"map for FZF
nnoremap <leader>t :call UnifiedFzf('files')<CR>
nnoremap <leader>b :call UnifiedFzf('buffers')<CR>
nnoremap <leader>z :Mz<CR>
nnoremap <leader>m :call UnifiedFzf('files', function('InsertPathSink'))<CR>

nnoremap <leader>d :Mt<CR>

augroup nvim_autocommands
  autocmd!
  autocmd BufWritePre * StripWhitespace
  autocmd BufNewFile,BufRead */gemini-edit-*/buffer.txt inoremap <buffer> @ @<C-o>:call UnifiedFzf('files', function('InsertPathSink'))<CR>
  autocmd BufNewFile,BufRead myprompts/*.md inoremap <buffer> @ @<C-o>:call UnifiedFzf('files', function('InsertPathSink'))<CR>
  autocmd BufNewFile,BufRead claude-prompt-*.md inoremap <buffer> @ @<C-o>:call UnifiedFzf('files', function('InsertPathSink'))<CR>
  autocmd FileType markdown,text inoremap <buffer> <CR> <CR><cmd>AutolistNewBullet<cr>
  autocmd FileType markdown,text nnoremap <buffer> o o<cmd>AutolistNewBullet<cr>
  autocmd FileType markdown,text nnoremap <buffer> O O<cmd>AutolistNewBulletBefore<cr>
  autocmd FileType markdown nnoremap <buffer> <silent> <leader>v <cmd>lua require('markdown_conf').toggle()<CR>
augroup END

"Old school Ag
command! -nargs=+ -complete=file Ag Grepper -noprompt -tool ag -query --hidden --ignore .git <args>

" In fugitive diff buffers, override the default slime mapping (<C-c><C-c>)
" so visual sends are wrapped with `path` + ```diff fence.
" Covers :Git diff, :Git diff --cached, and inline-expanded hunks in :G.
function! s:FugitiveDiffPath(start_line) abort
  for lnum in range(a:start_line, 1, -1)
    let line = getline(lnum)
    " :Git diff -- unified diff header
    let m = matchlist(line, '^diff --git a/\S\+ b/\(\S\+\)$')
    if !empty(m)
      return m[1]
    endif
    " :G status -- file marker line: "M f.txt", "D b.txt", "? new.txt", "R old -> new.txt"
    let m = matchlist(line, '^[MADRCU?!]\{1,2\} \(.*\)$')
    if !empty(m)
      let path = m[1]
      let arrow = stridx(path, ' -> ')
      return arrow >= 0 ? path[arrow + 4 :] : path
    endif
  endfor
  return ''
endfunction

function! s:SlimeSendFugitiveDiff() range
  let lines = getline(a:firstline, a:lastline)
  let path  = s:FugitiveDiffPath(a:firstline)
  if empty(path)
    call slime#send(join(lines, "\n") . "\n")
    return
  endif
  let body = '`' . path . "`\n```diff\n" . join(lines, "\n") . "\n```\n"
  call slime#send(body)
endfunction

augroup FugitiveSlimeDiff
  autocmd!
  autocmd FileType git,fugitive xnoremap <silent> <buffer> <C-c><C-c> :call <SID>SlimeSendFugitiveDiff()<CR>
augroup END

command! MdPreview execute 'silent !mdpreview ' . shellescape(expand('%:p')) | redraw!

command! Mt Mg '[-\*] *\[' *\*]'
