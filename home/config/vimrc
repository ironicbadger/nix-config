set nocompatible " we still use Vim instead of NVim sometimes

call plug#begin('~/.vim/plugged')

" General {{{
  set autoread " detect file changes
  set autowrite " Automatically :write before running commands
  set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp " keep backup files away from our normal files" 
  set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp " keep .swp files away from our normal files
  set textwidth=120
  " set colorcolumn=+1 " make it obvious where 120 characters is

  set history=1000 " keep more commands in history
  set backspace=indent,eol,start " Backspace deletes like most programs in insert mode
  " set clipboard=unnamed " use the system clipboard

  if has('mouse')
    set mouse=a " enable mouse in all modes
  endif

  " Searching
  set infercase " Smart casing when completing
  set ignorecase " Search in case-insensitively
  set smartcase " ... unless they contain at least one capital letter
  set hlsearch " highlight matches
  set incsearch " incremental searching
  if has('nvim')
    set inccommand=split " show results of substitutions inplace
  end

  set nolazyredraw " don't redraw while executing macros"

  " no beeps!
  set noerrorbells
  set visualbell
  set t_vb=
  set noerrorbells

  set timeoutlen=1000 " wait 1s for a command to be completed before timing out

  set splitbelow " open new splits below
  set splitright " open new splits to the right

  " When the type of shell script is /bin/sh, assume a POSIX-compatible
  " shell for syntax highlighting purposes.
  let g:is_posix = 1

  set nojoinspaces " use one space, not two, after punctuation.
  set complete+=kspell " autocomplete with dictionary words when spell check is on

  " Set the persistent undo directory on temporary private fast storage.
  let s:undoDir=$HOME . "/.vim-undodir" . $USER
  if !isdirectory(s:undoDir)
      call mkdir(s:undoDir, "", 0700)
  endif
  let &undodir=s:undoDir
  set undofile          " Maintain undo history
" }}}

" Appearance {{{
  set number " Show line numbers
  set relativenumber " show relative line numbers"
  set wrap " wrap lines
  set linebreak " wrap lines at breakat
  set showbreak=… " show ellipsis at breaking"
  set autoindent " automatically indent new lines
  set ttyfast " faster redrawing
  set diffopt+=vertical,iwhite,internal,algorithm:patience,hiddenoff " vertical splits, ignore whitespace,  patience diffing
  set laststatus=2  " Always display the status line
  set scrolloff=7 " minimunm amount of lines above and below cursor
  set wildmenu " enhanced command line completion"
  set wildmode=full
  set hidden " required for operations modifying multiple buffers like rename.
  set showcmd " display incomplete commands
  set noshowmode " powerline shows the mode
  set wildmode=list:longest,list:full " complete files like a shell"
  set cmdheight=1 " command bar height"
  set title " set terminal title"
  set showmatch " hightlight matching braces
  set matchtime=5 " tenths of seconds matches are highlighted
  set updatetime=250 " update swp file, fire CursorHold event
  set signcolumn=yes " show column next to line numbers (used by git gutter)
  set shortmess+=c " don't give ins-completion-menu messages"
  set breakindent " prettyier word wraps
  set breakindentopt=shift:2
  set showbreak=↳

  " Tab control
  set smarttab " tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
  set tabstop=2 " a tab is two spaces
  set softtabstop=2 " edit as if the tabs are 2 characters wide"
  set shiftwidth=2 " ident by two spaces
  set shiftround  " round indent to a multiple of 'shiftwidth'"
  set expandtab " use spaces, not tabs

  " code folding
  set foldmethod=syntax " fold based on syntax highlighting
  set foldlevelstart=99 " open all folds when opening a buffer
  set foldnestmax=10 " only fold 10 levels
  set nofoldenable " don't fold by default

  " toggle invisible characters
  set list
  set listchars=tab:→\ ,trail:⋅,extends:❯,precedes:❮ " eol:¬,
  set showbreak=↪

  set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors
  " switch cursor to line when in insert mode, and block when not
  set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175

  if &term =~ '256color'
      " disable background color erase
      set t_ut=
  endif

  " enable 24 bit color support if supported
  if (has("termguicolors"))
      if (!(has("nvim")))
          let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
          let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      endif
      set termguicolors
  endif

  " highlight conflicts
  match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

  set guifont=Menlo\ for\ Powerline:h13 " Set font for GUI
" }}}

" General Mappings {{{

  " space is our leader
  let mapleader = " "

  " jump over wrapped lines, but only when no cound is given, set mark when jumping far
  nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
  nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'

  " Remap the arrow keys to do nothing
  nnoremap <Left> :echoe "Use h"<CR>
  nnoremap <Right> :echoe "Use l"<CR>
  nnoremap <Up> :echoe "Use k"<CR>
  nnoremap <Down> :echoe "Use j"<CR>

  " Exit insert mode by pressing jj
  inoremap jj <ESC>

  " Switch between files by hitting ,, twice
  noremap ,, <c-^>

  " Navigate through splits more easily
  nnoremap <c-j> <c-w>j
  nnoremap <c-k> <c-w>k
  nnoremap <c-h> <c-w>h
  nnoremap <c-l> <c-w>l

  " double percentage sign in command mode is expanded
  " to directory of current file - http://vimcasts.org/e/14
  cnoremap %% <C-R>=expand('%:h').'/'<cr>

  map <leader>so :source ~/.vimrc<cr>:PlugInstall<cr>
  map <leader>sn :source ~/.vimrc<cr>
  map <leader>h :nohlsearch<cr>
  map <Leader>p cV

  " Swap 0 and ^. I tend to want to jump to the first non-whitesapce character
  " so make that the easier one to do.
  nnoremap 0 ^
  nnoremap ^ 0

  " Run commands that require an interactive shell
  nnoremap <Leader>r :RunInInteractiveShell<space>

  " zoom a vim pane, <C-w>= to re-balance
  nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
  nnoremap <leader>= :wincmd =<cr>

  " keep visual selection when indenting/outdenting
  vmap < <gv
  vmap > >gv

  " move line mappings
  " ∆ is <A-j> on macOS
  " ˚ is <A-k> on macOS
  nnoremap ∆ :m .+1<cr>==
  nnoremap ˚ :m .-2<cr>==
  inoremap ∆ <Esc>:m .+1<cr>==gi
  inoremap ˚ <Esc>:m .-2<cr>==gi
  vnoremap ∆ :m '>+1<cr>gv=gv
  vnoremap ˚ :m '<-2<cr>gv=gv

  " scroll the viewport faster
  nnoremap <C-e> 3<C-e>
  nnoremap <C-y> 3<C-y>

  " Y yanks until the end of line
  noremap Y y$

  "-----------------------------
  " Readline-like mappings
  "-----------------------------
  " - Ctrl-a - go to the start of line
  " - Ctrl-e - go to the end of the line
  " - Alt-b  - back a word
  " - Alt-f  - forward a word
  " - Alt-BS - delete backward word
  " - Alt-d  - delete forward word
  inoremap <C-a>  <C-o>^
  inoremap <C-e>  <C-o>$
  inoremap <A-b>  <C-Left>
  inoremap <A-f>  <C-Right>
  inoremap <A-BS> <C-w>
  inoremap <A-d>  <C-o>dw
  " As above but for command mode.
  cnoremap <C-a>  <Home>
  cnoremap <C-e>  <End>
  cnoremap <A-b>  <C-Left>
  cnoremap <A-f>  <C-Right>
  cnoremap <A-BS> <C-w>
  cnoremap <A-d>  <C-Right><C-w>

  "-----------------------------
  " Completion mappings
  "-----------------------------
  " - ]     - 'tags' file completion
  " - Space - context aware omni completion (via 'omnifunc' setting)
  " - b     - keyword completion from the current buffer (<C-n><C-b> to extend)
  " - d     - dictionary completion (via 'dictionary' setting)
  " - f     - file path completion
  " - l     - line completion (repeat an existing line)
  " inoremap <C-]>     <C-x><C-]>
  " inoremap <C-Space> <C-x><C-o>
  " inoremap <C-b>     <C-x><C-p>
  " inoremap <C-d>     <C-x><C-k>
  " inoremap <C-f>     <C-x><C-f>
  " inoremap <C-l>     <C-x><C-l>
  " " - c - term completion that combines the sources of the 'complete' option
  " inoremap <expr> <C-c> pumvisible() ? "\<C-e>\<C-n>": "\<C-n>"
" }}}

" {{{ Project Notes
  " Quick access to a local notes file for keeping track of things in a given
  " project. Add `.project-notes` to global ~/.gitignore

  let s:PROJECT_NOTES_FILE = '.project-notes'

  command! EditProjectNotes call <sid>SmartSplit(s:PROJECT_NOTES_FILE)
  nnoremap <leader>ep :EditProjectNotes<cr>

  autocmd BufEnter .project-notes call <sid>LoadNotes()

  function! s:SmartSplit(file)
    let split_cmd = (winwidth(0) >= 100) ? 'vsplit' : 'split'
    execute split_cmd . " " . a:file
  endfunction

  function! s:LoadNotes()
    setlocal filetype=markdown
    nnoremap <buffer> q :wq<cr>
  endfunction
" }}}

" Functions {{{

  " Display relative line numbers in the active window and display absolute
  " numbers in inactive windows.
  "
  function! s:RelativeNumberActivity(mode) abort
    if &diff
      " For diffs, do nothing since we want relativenumbers in all windows.
      return
    endif
    if &buftype == "nofile" || &buftype == "nowrite"
      setlocal nonumber
    elseif a:mode == "active"
      setlocal relativenumber
    else
      setlocal norelativenumber
    endif
  endfunction

  " Toggle spelling mode, add the dictionary to the completion list of
  " sources if spelling mode has been entered, otherwise remove it.
  "
  function! s:SpellingToggle() abort
    setlocal spell!
    if &spell
      set complete+=kspell
      echo "Spell mode enabled"
    else
      set complete-=kspell
      echo "Spell mode disabled"
    endif
  endfunction

  nnoremap <F5>     :call <SID>SpellingToggle()<CR>
  nnoremap <Space>5 :call <SID>SpellingToggle()<CR>

" }}}

" AutoGroups {{{
  augroup configgroup
    autocmd!
    " automatically rebalance windows on vim resize
    autocmd VimResized * wincmd =

    " save all files on focus lost, ignoring warnings about untitled buffers
    autocmd FocusLost * silent! wa

    " make quickfix windows take all the lower section of the screen
    " when there are multiple windows open
    autocmd FileType qf wincmd J
    autocmd FileType qf nmap <buffer> q :q<cr>

    autocmd WinEnter * call s:RelativeNumberActivity("active")
    autocmd WinLeave * call s:RelativeNumberActivity("inactive")

    " Syntax highlight a minimum of 2,000 lines. This greatly helps scroll
    " performance.
    autocmd Syntax * syntax sync minlines=2000
  augroup END
" }}}

" General {{{ 
" Load matchit.(will only be executed on Vim)
  if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
    runtime! macros/matchit.vim
  endif

  " search inside files using 
  Plug 'mhinz/vim-grepper'
  let g:grepper       = {}
  let g:grepper.tools = ["rg"]
  let g:grepper.highlight  = 1
  let g:grepper.stop  = 1000

  " Search for user-supplied term.
  nnoremap <Leader>/ :GrepperRg<Space>
  " Search for current word or selection.
  nnoremap gs :Grepper -cword -noprompt<CR>
  xmap gs <Plug>(GrepperOperator)

  " session management
  Plug 'tpope/vim-obsession'
  noremap <Leader>o :Obsession<CR>
  noremap <Leader>O :Obsession!<CR>

  " easy commenting motions
  Plug 'tpope/vim-commentary'

  " mappings which are simply short normal mode aliases for commonly used ex commands
  Plug 'tpope/vim-unimpaired'

  " endings for html, xml, etc. - ehances surround
  Plug 'tpope/vim-ragtag'

  " mappings to easily delete, change and add such surroundings in pairs, such as quotes, parens, etc.
  Plug 'tpope/vim-surround'

  " enables repeating other supported plugins with the . command
  Plug 'tpope/vim-repeat'
  " map U to redo
  nmap U <Plug>(RepeatRedo)

  " .editorconfig support
  Plug 'editorconfig/editorconfig-vim'

  " single/multi line code handler: gS - split one line into multiple, gJ - combine multiple lines into one
  Plug 'AndrewRadev/splitjoin.vim'

  " add end, endif, etc. automatically
  Plug 'tpope/vim-endwise'

  " detect indent style (tabs vs. spaces)
  Plug 'tpope/vim-sleuth'

  " Close buffers but keep splits
  Plug 'moll/vim-bbye'
  nmap <leader>b :Bdelete<cr>

  " context-aware pasting
  Plug 'sickill/vim-pasta'

  if has("wsl")
    let g:system_copy#paste_command='win32yank.exe -o'
    let g:system_copy#copy_command='win32yank.exe -i'
  endif
  " add `cp` operator to copy text to system clipboard via text object or motion
  " `cp`/`cP` to copy, `cv`/``cV` to paste
  Plug 'christoomey/vim-system-copy'

  " automatically make intermediate directories if needed
  Plug 'pbrisbin/vim-mkdir'

  " add handful of UNIXy commands to Vim
  Plug 'tpope/vim-eunuch'

  " * to search for word selected in visual mode
  Plug 'nelstrom/vim-visual-star-search'

  " accept file_name.rb:23 style files
  Plug 'bogado/file-line'

  " automatically align lines
  Plug 'junegunn/vim-easy-align'

  " <leader><leader>w to jump to words
  Plug 'easymotion/vim-easymotion'

  " Highlight yanked portion
  Plug 'machakann/vim-highlightedyank'

  " automatically insert matching brackets
  Plug 'jiangmiao/auto-pairs'

  " `cx` Operator for exchanging text regions
  Plug 'tommcdo/vim-exchange'

  " remember last position in normal files, excluding commits, help, quickfix etc
  Plug 'farmergreg/vim-lastplace'


  " highlight the word under the cursor
  Plug 'RRethy/vim-illuminate'

  " Make f and t repeatable
  Plug 'rhysd/clever-f.vim'

  Plug 'mbbill/undotree'
  let g:undotree_HighlightChangedWithSign = 0
  let g:undotree_WindowLayout             = 4
  nnoremap <Leader>u :UndotreeToggle<CR>

  Plug 'gcmt/taboo.vim'
  let g:taboo_tab_format = " tab:%N%m "

  nnoremap <Leader>1 1gt
  nnoremap <Leader>2 2gt
  nnoremap <Leader>3 3gt
  nnoremap <Leader>4 4gt
  nnoremap <Leader>5 5gt
" }}}

" Text objects {{{
  " create custom text objects
  Plug 'kana/vim-textobj-user'
  " `al` and `il` mappings to work on lines without surrounding spaces
  Plug 'kana/vim-textobj-line'
  " `ai`, `aI`, `ii`, `iI` mappings for interacting based on indention
  Plug 'kana/vim-textobj-indent'
  " `ae` and `ie` mapping to work with the entire buffer
  Plug 'kana/vim-textobj-entire'
  " `aq` and `iq` mappings to work insite quotes
  Plug 'beloglazov/vim-textobj-quotes'
  " `ac` and `ic` mappings to work with code blocks
  Plug 'christoomey/vim-textobj-codeblock'
  " adds a bunch of textobjects like `i,`
  Plug 'wellle/targets.vim'

"" }}}

" Themes {{{
  Plug 'nanotech/jellybeans.vim'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'airblade/vim-gitgutter'
" }}}

" NERDTree {{{
  Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'ryanoasis/vim-devicons'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  let g:WebDevIconsOS = 'Darwin'
  let g:WebDevIconsUnicodeDecorateFolderNodes = 1
  let g:DevIconsEnableFoldersOpenClose = 1
  let g:DevIconsEnableFolderExtensionPatternMatching = 1
  let NERDTreeDirArrowExpandable = "\u00a0" " make arrows invisible
  let NERDTreeDirArrowCollapsible = "\u00a0" " make arrows invisible
  let NERDTreeNodeDelimiter = "\u263a" " smiley face

  augroup nerdtree
    autocmd!
    autocmd FileType nerdtree setlocal nolist " turn off whitespace characters
    autocmd FileType nerdtree setlocal nocursorline " turn off line highlighting for performance
  augroup END

  " Toggle NERDTree
  function! ToggleNerdTree()
    if @% != "" && @% !~ "Startify" && (!exists("g:NERDTree") || (g:NERDTree.ExistsForTab() && !g:NERDTree.IsOpen()))
      :NERDTreeFind
    else
      :NERDTreeToggle
    endif
  endfunction
  " toggle nerd tree
  nmap <silent> <leader>k :call ToggleNerdTree()<cr>
  " find the current file in nerdtree without needing to reload the drawer
  nmap <silent> <leader>y :NERDTreeFind<cr>

  let NERDTreeShowHidden=1
  " let NERDTreeDirArrowExpandable = '▷'
  " let NERDTreeDirArrowCollapsible = '▼'
  let g:NERDTreeIndicatorMapCustom = {
        \ "Modified"  : "✹",
        \ "Staged"    : "✚",
        \ "Untracked" : "✭",
        \ "Renamed"   : "➜",
        \ "Unmerged"  : "═",
        \ "Deleted"   : "✖",
        \ "Dirty"     : "✗",
        \ "Clean"     : "✔︎",
        \ 'Ignored'   : '☒',
        \ "Unknown"   : "?"
        \ }
" }}}

" FZF {{{
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
  let g:fzf_layout = { 'down': '~25%' }
  Plug 'pbogut/fzf-mru.vim'

 " let g:fzf_commits_log_options = '--graph --color=always
  "       \ --date=human --format="%C(#e3c78a)%h%C(#ff5454)%d%C(reset)
  "       \ - %C(#42cf89)(%ad)%C(reset) %s %C(#80a0ff){%an}%C(reset)"'

  if isdirectory(".git")
    " if in a git project, use :GFiles
    nmap <silent> <C-p> :GitFiles --cached --others --exclude-standard<cr>
  else
    " otherwise, use :FZF
    nmap <silent> <C-p> :FZF<cr>
  endif

  nnoremap <silent> <leader><Space> :Files<CR>
  nnoremap <silent> <leader>,       :Buffers<CR>
  nnoremap <silent> <leader><BS>    :BDelete<CR>
  nnoremap <silent> <leader>]       :Tags<CR>
  nnoremap <silent> <leader>[       :BTags<CR>
  nnoremap <silent> <leader>c       :BCommits<CR>
  nnoremap <silent> <leader>g       :GFiles?<CR>
  nnoremap <silent> <leader>h       :Helptags<CR>

  nmap <leader>? <plug>(fzf-maps-n)
  xmap <leader>? <plug>(fzf-maps-x)
  omap <leader>? <plug>(fzf-maps-o)
  imap <C-x>?   <Plug>(fzf-maps-i)

  " Insert mode completion
  imap <c-x><c-k> <plug>(fzf-complete-word)
  imap <c-x><c-f> <plug>(fzf-complete-path)
  imap <c-x><c-j> <plug>(fzf-complete-file-ag)
  imap <c-x><c-l> <plug>(fzf-complete-line)

  nnoremap <silent> <Leader>C :call fzf#run({
        \   'source':
        \     map(split(globpath(&rtp, "colors/*.vim"), "\n"),
        \         "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
        \   'sink':    'colo',
        \   'options': '+m',
        \   'left':    30
        \ })<CR>

  " command! FZFMru call fzf#run({
  "       \  'source':  v:oldfiles,
  "       \  'sink':    'e',
  "       \  'options': '-m -x +s',
  "       \  'down':    '40%'})
  nnoremap <silent> <Space>m :FZFMru<CR>

  command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
        \   fzf#vim#with_preview(), <bang>0)
  command! -bang -nargs=* Find call fzf#vim#grep(
        \ 'rg --column --line-number --no-heading --follow --color=always '.<q-args>, 1,
        \ <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)
  command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:50%', '?'), <bang>0)
  command! -bang -nargs=? -complete=dir GitFiles
        \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview('right:50%', '?'), <bang>0)
" }}}

" git {{{
  Plug 'tpope/vim-fugitive'
  nmap <silent> <leader>gs :Gstatus<cr>
  nmap <leader>ge :Gedit<cr>
  nmap <silent><leader>gr :Gread<cr>
  nmap <silent><leader>gb :Gblame<cr>

  " GitLab integration
  Plug 'shumphrey/fugitive-gitlab.vim'
  let g:fugitive_gitlab_domains = ['https://git.dsander.de', 'http://gitlab.flavoursys.lan']

  " GitHub integration 
  Plug 'tpope/vim-rhubarb'

  " Show commit messages for the current line
  Plug 'rhysd/git-messenger.vim'
  let g:git_messenger_no_default_mappings = v:true
  nmap <Leader>M <Plug>(git-messenger)
" }}}

" UltiSnips {{{
  Plug 'SirVer/ultisnips' " Snippets plugin
  let g:UltiSnipsExpandTrigger="<C-l>"
  let g:UltiSnipsJumpForwardTrigger="<C-j>"
  let g:UltiSnipsJumpBackwardTrigger="<C-k>"
" }}}

" coc {{{
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  let g:coc_global_extensions = [
        \ 'coc-css',
        \ 'coc-emmet',
        \ 'coc-eslint',
        \ 'coc-git',
        \ 'coc-html',
        \ 'coc-json',
        \ 'coc-pairs',
        \ 'coc-prettier',
        \ 'coc-rust-analyzer',
        \ 'coc-sh',
        \ 'coc-solargraph',
        \ 'coc-tslint-plugin',
        \ 'coc-tsserver',
        \ 'coc-ultisnips',
        \ 'coc-vimlsp',
        \ 'coc-yaml',
        \ ]

  autocmd CursorHold * silent call CocActionAsync('highlight')

  " coc-prettier
  command! -nargs=0 Prettier :CocCommand prettier.formatFile
  nmap <leader>f :CocCommand prettier.formatFile<cr>

  " coc-git
  nmap [g <Plug>(coc-git-prevchunk)
  nmap ]g <Plug>(coc-git-nextchunk)
  nmap gs <Plug>(coc-git-chunkinfo)
  nmap gu :CocCommand git.chunkUndo<cr>

  "remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> gh <Plug>(coc-doHover)

  " diagnostics navigation
  nmap <silent> [c <Plug>(coc-diagnostic-prev)
  nmap <silent> ]c <Plug>(coc-diagnostic-next)

  " rename
  nmap <silent> <leader>rn <Plug>(coc-rename)

  " Remap for format selected region
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  " organize imports
  command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Use tab for trigger completion with characters ahead and navigate.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction
" }}}

" Tmux / test runner {{{
  Plug 'edkolev/tmuxline.vim'
  " Seamlessly navigate between vim splits and tmux panes
  Plug 'christoomey/vim-tmux-navigator'
  " FocusGained and FocusLost autocommand events are not working in terminal vim. This plugin restores them when using vim inside Tmux.
  Plug 'tmux-plugins/vim-tmux-focus-events'

  Plug 'janko-m/vim-test'
  " let test#strategy = "asyncrun"
  let test#strategy = "dispatch"
  " vim-test mappings
  nnoremap <silent> <Leader>t :TestFile<CR>
  nnoremap <silent> <Leader>s :TestNearest<CR>
  nnoremap <silent> <Leader>l :TestLast<CR>
  nnoremap <silent> <Leader>a :TestSuite<CR>
  nnoremap <silent> <leader>gt :TestVisit<CR>
  " let test#ruby#rspec#executable = 'bundle exec rspec'

  Plug 'tpope/vim-dispatch'
  " Plug 'skywind3000/asyncrun.vim'

  " Connect Vim and tmux to allow running lines & commands
  Plug 'christoomey/vim-tmux-runner'
  nnoremap <leader>rr :VtrResizeRunner<cr>
  nnoremap <leader>ror :VtrReorientRunner<cr>
  nnoremap <leader>sc :VtrSendCommandToRunner<cr>
  vnoremap <leader>sl :VtrSendLinesToRunner<cr>
  nnoremap <leader>or :VtrOpenRunner<cr>
  nnoremap <leader>kr :VtrKillRunner<cr>
  nnoremap <leader>fr :VtrFocusRunner<cr>
  nnoremap <leader>dr :VtrDetachRunner<cr>
  nnoremap <leader>ar :VtrReattachRunner<cr>
  nnoremap <leader>cr :VtrClearRunner<cr>
  nnoremap <leader>fc :VtrFlushCommand<cr>
" }}}

" Language specific {{{
  " polygot - contains a bunch of language plugin
  Plug 'sheerun/vim-polyglot'

  " html {{{
    " emmet support for vim - easily create markdup wth CSS-like syntax
    Plug 'mattn/emmet-vim'

    " match tags in html, similar to paren support
    Plug 'gregsexton/MatchTag', { 'for': 'html' }

  " }}}

  " " Ruby {{{
    Plug 'tpope/vim-bundler'
    Plug 'tpope/vim-rails'
    Plug 'tpope/vim-rake'
    " `ir`, `ar` mappings for ruby code blocks
    Plug 'nelstrom/vim-textobj-rubyblock'
    Plug 'thoughtbot/vim-rspec'
    let g:rspec_runner = "dispatch"
    " let g:rspec_command = "!clear && bin/rspec {spec}"
    " let g:rspec_command = "compiler rspec | set makeprg=bundle\\ exec\\ rspec | make {spec}"
    
    Plug 'christoomey/vim-rfactory'

    nnoremap <leader>gf :call <sid>SmartSplit()<cr>

    function! s:SmartSplit()
      let split_cmd = (winwidth(0) > 106) ? 'RVfactory' : 'RSfactory'
      execute split_cmd
    endfunction
  " }}}

  " Templates / Config file formats {{{
    function! s:PrettyJSON()
      %!jq .
      set filetype=json
    endfunction
    command! PrettyJSON :call <sid>PrettyJSON()

    " Open markdown files in Marked.app - mapped to <leader>m
    Plug 'itspriddle/vim-marked', { 'for': 'markdown', 'on': 'MarkedOpen' }
    nmap <leader>md :MarkedOpen!<cr>
    nmap <leader>mdq :MarkedQuit<cr>
    nmap <leader>* *<c-o>:%s///gn<cr>

  " }}}

  " JavaScript {{{
    Plug 'othree/yajs.vim', { 'for': [ 'javascript', 'javascript.jsx', 'html' ] }
    Plug 'moll/vim-node', { 'for': 'javascript' }
    Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'], 'do': 'npm install' }
  " }}}

  " Styles {{{
    Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
    Plug 'stephenway/postcss.vim', { 'for': 'css' }
  " }}}
" }}}

call plug#end() " Initialize plugin system

" Colorscheme and final setup {{{
  " This call must happen after the plug#end() call to ensure
  " that the colorschemes have been loaded

  " Set Theme
  try
    colorscheme jellybeans
  catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
  endtry
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#tabline#enabled = 1

  syntax on
  filetype plugin indent on
  hi illuminatedWord guibg=#333333
" }}}

" vim: ft=vim foldmethod=marker foldlevel=0
