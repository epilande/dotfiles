""""""""""""""""""""""""""""""""""""""""""""""""""
" => PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.vim/plugged')

" Interactive command execution
Plug 'Shougo/vimproc.vim', { 'do': 'make' }

" Unite. The interface to rule almost everything
" Plug 'Shougo/unite.vim'

" Most Recently Used
Plug 'Shougo/neomru.vim'

" Command-line fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

if has('nvim')
  " Asynchronous completion for neovim
  Plug 'Shougo/deoplete.nvim'
  " Tern-based JavaScript editing support
  Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
else
  " Code completion
  Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }
endif

" Emmet for vim
Plug 'mattn/emmet-vim'

" Code search and view tool
Plug 'dyng/ctrlsf.vim'

" BufExplorer quickly and easily switch between buffer
Plug 'jlanzarotta/bufexplorer'

" Tree explorer for vim.
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Asynchronous linter
Plug 'benekastah/neomake'

" Cache file automatically
Plug 'MarcWeber/vim-addon-mw-utils'

" Lean & mean status/tabline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Comment stuff out
Plug 'tpope/vim-commentary'

" Visually select larger regions of text using the same key combination
Plug 'terryma/vim-expand-region'

" Git wrapper
Plug 'tpope/vim-fugitive'

" SCSS syntax highlighting
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }

" Markdown syntax highlighting
Plug 'plasticboy/vim-markdown', { 'for': 'md' }

" Enable repeating supported plugin maps
Plug 'tpope/vim-repeat'

" Ultimate snippet solution
Plug 'SirVer/ultisnips'

" Snippet files for various programming languages
Plug 'honza/vim-snippets'

" Quoting/parenthesizing made simple
Plug 'tpope/vim-surround'

" Display indention levels with vertical lines
Plug 'Yggdroot/indentLine'

" Tmux statusline generator with support for airline
Plug 'edkolev/tmuxline.vim'

" Undo history visualizer
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

" Preview colors in source code
Plug 'ap/vim-css-color'

" CSS3 syntax support
Plug 'hail2u/vim-css3-syntax'

" Vim motions on speed
" Plug 'easymotion/vim-easymotion'

" Shows a git diff in the gutter
Plug 'airblade/vim-gitgutter'

" Instant Markdown previews
Plug 'suan/vim-instant-markdown'

" Jade syntax highlighting
Plug 'digitaltoad/vim-jade', { 'for': 'jade' }

" Javascript indentation and syntax support
Plug 'pangloss/vim-javascript'

" Yet Another JavaScript Syntax
Plug 'othree/yajs.vim'

" Sublime Text style multiple selections
" Plug 'terryma/vim-multiple-cursors'

" Seamless navigation between tmux panes and vim splits
Plug 'christoomey/vim-tmux-navigator'

" Add filetype glyphs (icons)
Plug 'ryanoasis/vim-devicons'

" Zoom in/out of windows
Plug 'troydm/zoomwintab.vim'

" Gotham colorscheme
Plug 'whatyouhide/vim-gotham'

" Oceanic Next colorscheme
Plug 'mhartington/oceanic-next'

" Solarized colorscheme
Plug 'altercation/vim-colors-solarized'

" Vim Orgmode
Plug 'jceb/vim-orgmode', { 'for': 'org' }

" Increment dates, times, and more
Plug 'tpope/vim-speeddating'

" Insert or delete brackets, parens, quotes in pair
Plug 'jiangmiao/auto-pairs'

" Tern-based JavaScript editing support
" Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }

" React JSX syntax highlighting & indenting
Plug 'mxw/vim-jsx'

" EditorConfig for consistent coding style
Plug 'editorconfig/editorconfig-vim'

" Provides additional text objects
Plug 'wellle/targets.vim'

" Speed up Vim by updating folds only when called-for
Plug 'Konfekt/FastFold'

" Metrics, insights, and time tracking
Plug 'wakatime/vim-wakatime'

call plug#end()



""""""""""""""""""""""""""""""""""""""""""""""""""
" => PLUGIN SPECIFC CONFIGURATIONS
""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" bufExplorer plugin
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='mru'
map <leader>o :BufExplorer<cr>


""""""""""""""""""""""""""""""
" MRU plugin
""""""""""""""""""""""""""""""
let MRU_Max_Entries = 400


""""""""""""""""""""""""""""""
" Unite.vim
""""""""""""""""""""""""""""""

" Use the fuzzy matcher for everything
" call unite#filters#matcher_default#use(['matcher_fuzzy'])
" call unite#filters#converter_default#use(['converter_relative_word'])
" call unite#filters#sorter_default#use(['sorter_rank'])
" call unite#custom#source('file_mru,file_rec,file_rec/async', 'converters', 'converter_relative_word')

" Restrict mru to display files for current project
" call unite#custom#source(
"   \ 'file_mru', 'matchers',
"   \ ['matcher_project_files', 'matcher_fuzzy'])

" call unite#custom#profile('default', 'context', {
"   \ 'cursor_line_highlight' : 'CursorLine',
"   \ 'start_insert': 1,
"   \ 'winheight': 10,
"   \ 'direction': 'botright',
"   \ })

" Set up some custom ignores
" call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
"   \ 'ignore_pattern', join([
"   \ '\.git/',
"   \ 'tmp/',
"   \ '.sass-cache',
"   \ 'node_modules/',
"   \ 'bower_components/',
"   \ 'dist/',
"   \ '.pyc',
"   \ ], '\|'))

" let g:unite_data_directory='~/.vim/.cache/unite'
" let g:unite_source_history_yank_enable=1
" let g:unite_source_rec_max_cache_files=5000
" let g:unite_source_file_mru_limit=200
" let g:unite_source_rec_async_command =
"       \ ['ag', '--follow', '--nocolor', '--nogroup',
"       \  '--hidden', '-g', '']
" let g:unite_source_grep_command = 'ag'
" let g:unite_source_grep_default_opts = '-s -H --nocolor --nogroup --column'
" let g:unite_source_grep_recursive_opt = ''
" let g:unite_prompt='❯ '

" nnoremap <C-f> :<C-u>Unite -buffer-name=files file_mru file_rec/async:!<CR>
" nnoremap <leader>f :<C-u>Unite -no-split -no-resize -direction=topleft -buffer-name=mru file_mru<CR>
" nnoremap <leader>y :<C-u>Unite -no-start-insert history/yank<CR>
" nnoremap <leader>/ :<C-u>Unite grep:.<CR>

" Custom mappings for the unite buffer
" autocmd FileType unite call s:unite_keymaps()

" function! s:unite_keymaps()
"   " Enable navigation with control-j and control-k in insert mode
"   imap <buffer> <C-j>   <Plug>(unite_select_next_line)
"   imap <buffer> <C-k>   <Plug>(unite_select_previous_line)

"   " Exit unite with Esc while in insert mode
"   nmap <buffer> <Esc>   <Plug>(unite_exit)
"   imap <buffer> <Esc>   <Plug>(unite_exit)
" endfunction


""""""""""""""""""""""""""""""
" FZF
""""""""""""""""""""""""""""""
let g:fzf_layout = { 'down': '40%' }
" Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" Search project files, respecting git ignore
nnoremap <silent> <C-f> :FZF<CR>
" Search all files, e.g. node_modules/
nnoremap <silent> <leader>af :call fzf#vim#files('',
      \ {'source': 'ag --hidden --ignore .git -f -g "" -u', 'down': '40%'})<CR>
" Search MRU buffers
nnoremap <silent> <leader>f :Buffers<CR>
nnoremap <silent> <leader>` :Marks<CR>

" [Tags] Command to generate tags file
" let g:fzf_tags_command = 'ctags -R --exclude=.git --exclude=node_modules --exclude=test'
nnoremap <silent> <leader>t :Tags<CR>


""""""""""""""""""""""""""""""
" NERDTree
""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "left"
let g:NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.js.map$', '\.DS_Store$']
let g:NERDTreeWinSize=35
map <C-e> :NERDTreeToggle<CR>


""""""""""""""""""""""""""""""
" vim-multiple-cursors
""""""""""""""""""""""""""""""
let g:multi_cursor_next_key="\<C-s>"


""""""""""""""""""""""""""""""
" vim airline
""""""""""""""""""""""""""""""
let g:airline#extensions#branch#displayed_head_limit = 10
let g:airline_powerline_fonts = 1
if has("gui_running")
  let g:airline_theme="luna"
else
  let g:airline_theme="oceanicnext"
endif

" Automatically truncate sections
let g:airline#extensions#default#section_truncate_width = {
  \ 'b': 100,
  \ 'x': 100,
  \ 'y': 105,
  \ 'z': 50,
  \ 'warning': 50,
  \ }


""""""""""""""""""""""""""""""
" vim-easymotion
""""""""""""""""""""""""""""""
" map s <Plug>(easymotion-s)
" map <leader>s <Plug>(easymotion-s2)
" map <leader>_ <Plug>(easymotion-prefix)

" " match lower & upper case
" let g:EasyMotion_smartcase = 1

" let g:EasyMotion_use_smartsign_us = 1

" map <leader>l <Plug>(easymotion-lineforward)
" map <leader>j <Plug>(easymotion-j)
" map <leader>k <Plug>(easymotion-k)
" map <leader>h <Plug>(easymotion-linebackward)

" let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion


""""""""""""""""""""""""""""""
" vim-fugitive
""""""""""""""""""""""""""""""
map <leader>gg :GitGutterToggle<CR>
map <leader>gs :Gstatus<CR>
set diffopt+=vertical


""""""""""""""""""""""""""""""
" Deoplete
""""""""""""""""""""""""""""""
if has('nvim')
  " Enable deoplete.
  let g:deoplete#enable_at_startup = 1

  if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
  endif

  augroup omnifuncs
    autocmd!
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=tern#Complete
  augroup end

  let g:tern_request_timeout = 1
  let g:tern_show_argument_hints = 'on_hold'
  let g:tern_show_signature_in_pum = 0

  " Automatically close preview window after autocompletion
  autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
endif


""""""""""""""""""""""""""""""
" Ultisnips
""""""""""""""""""""""""""""""
" Trigger configuration
let g:UltiSnipsExpandTrigger="<C-l>"
" let g:UltiSnipsJumpForwardTrigger="<Tab>"
" let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"


""""""""""""""""""""""""""""""
" vim-instant-markdown
""""""""""""""""""""""""""""""
let g:instant_markdown_slow = 1
let g:instant_markdown_autostart = 0


""""""""""""""""""""""""""""""
" vim markdown
""""""""""""""""""""""""""""""
let g:vim_markdown_folding_disabled=1


""""""""""""""""""""""""""""""
" undotree
""""""""""""""""""""""""""""""
map <leader>u :UndotreeToggle<CR>
let g:undotree_WindowLayout = 3
let g:undotree_SplitWidth = 35
let g:undotree_SetFocusWhenToggle = 1

if has("persistent_undo")
  set undodir='~/.undodir/'
  set undofile
endif


""""""""""""""""""""""""""""""
" ZoomWin
""""""""""""""""""""""""""""""
nnoremap <silent> <leader>z :ZoomWinTabToggle<cr>


""""""""""""""""""""""""""""""
" CtrlSF
""""""""""""""""""""""""""""""
" Prompt CtrlSF using ALT+f
nmap ƒ <Plug>CtrlSFPrompt
vmap ƒ <Plug>CtrlSFVwordPath

" Toggle CtrlSF result display
map † :CtrlSFToggle<CR>

let g:ctrlsf_indent = 2


""""""""""""""""""""""""""""""
" Vim Orgmode
""""""""""""""""""""""""""""""
let g:org_export_emacs="/usr/local/bin/emacs"
let g:org_agenda_files = ['~/Desktop/Notes/daily-notes.org']
let g:org_todo_keywords = ['TODO', '|', 'DONE']
let g:org_aggressive_conceal = 1


""""""""""""""""""""""""""""""
" Tmuxline
""""""""""""""""""""""""""""""
let g:tmuxline_preset = {
  \"a"    : "#S",
  \"b"    : "#(ifconfig en0 | grep 'inet ' | awk '{print $2}')",
  \"c"    : "",
  \"win"  : "#I  #W",
  \"cwin" : "#I  #W",
  \"x"    : ["♫ #(source ~/.tmux/current-pianobar-song.sh)"],
  \"y"    : ["%a", "%b %d", "%R"],
  \"z"    : "#h",
  \'options' : {'status-justify' : 'left'}}

let g:tmuxline_separators = {
  \ 'left' : '',
  \ 'left_alt': '',
  \ 'right' : '',
  \ 'right_alt' : '',
  \ 'space' : ' '}


""""""""""""""""""""""""""""""
" vim-jsx
""""""""""""""""""""""""""""""
let g:jsx_ext_required = 0 " Allow JSX in normal JS files


""""""""""""""""""""""""""""""
" Neomake
""""""""""""""""""""""""""""""
autocmd! BufWritePost * Neomake
let g:neomake_open_list = 2
let g:neomake_list_height = 7

let g:neomake_stylelint = {
  \ 'errorformat': '%+P%f, %W%l:%c%*\s%m, %-Q',
  \ }

let g:neomake_warning_sign = {
  \ 'text': 'W',
  \ 'texthl': 'GitGutterChangeDefault',
  \ }

let g:neomake_error_sign = {
  \ 'text': 'E',
  \ 'texthl': 'GitGutterDeleteDefault',
  \ }

let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_json_enabled_makers = ['jsonlint']
let g:neomake_css_stylelint_maker = neomake_stylelint
let g:neomake_scss_stylelint_maker = neomake_stylelint
let g:neomake_css_enabled_makers = ['stylelint']
let g:neomake_scss_enabled_makers = ['stylelint']


""""""""""""""""""""""""""""""
" EditorConfig
""""""""""""""""""""""""""""""
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

