""""""""""""""""""""""""""""""""""""""""""""""""""
" => PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.vim/plugged')

" Interactive command execution
Plug 'Shougo/vimproc.vim', { 'do': 'make' }

" Fuzzy file, buffer, mru, tag, etc finder
" Plug 'ctrlpvim/ctrlp.vim'

" Unite. The interface to rule almost everything
Plug 'Shougo/unite.vim'

" Most Recently Used
Plug 'Shougo/neomru.vim'

" Neo-completion with cache
" Plug 'Shougo/neocomplete.vim'

" Code completion
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }

" Emacs's kill-ring for vim
" Plug 'maxbrunsfeld/vim-yankstack'

" Emmet for vim
Plug 'mattn/emmet-vim'


" BufExplorer quickly and easily switch between buffer
Plug 'jlanzarotta/bufexplorer'

" Tree explorer for vim.
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Snippet files for various programming languages
Plug 'honza/vim-snippets'

" Syntax checking
Plug 'scrooloose/syntastic'

" Cache file automatically
Plug 'MarcWeber/vim-addon-mw-utils'

" Lean & mean status/tabline
Plug 'bling/vim-airline'

" Comment stuff out
Plug 'tpope/vim-commentary'

" Visually select larger regions of text using the same key combination
Plug 'terryma/vim-expand-region'

" Git wrapper
Plug 'tpope/vim-fugitive'

" LESS syntax highlighting
Plug 'groenewege/vim-less'

" SCSS syntax highlighting
Plug 'cakebaker/scss-syntax.vim'

" Markdown syntax highlighting
Plug 'plasticboy/vim-markdown'

" Enable repeating supported plugin maps
Plug 'tpope/vim-repeat'

" Ultimate snippet solution
Plug 'SirVer/ultisnips'

" Quoting/parenthesizing made simple
Plug 'tpope/vim-surround'

" Display indention levels with vertical lines
Plug 'Yggdroot/indentLine'

" Tmux statusline generator with support for airline
Plug 'edkolev/tmuxline.vim'

" Typescript syntax highlighting
Plug 'leafgarland/typescript-vim'

" Undo history visualizer
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

" Preview colors in source code
Plug 'ap/vim-css-color'

" CSS3 syntax support
Plug 'hail2u/vim-css3-syntax'

" Vim Workspace Controller
Plug 'szw/vim-ctrlspace'

" Vim motions on speed
Plug 'easymotion/vim-easymotion'

" Shows a git diff in the gutter
Plug 'airblade/vim-gitgutter'

" Instant Markdown previews
Plug 'suan/vim-instant-markdown'

" Jade syntax highlighting
Plug 'digitaltoad/vim-jade'

" Javascript indentation and syntax support
Plug 'pangloss/vim-javascript'

" Enhanced javascript syntax
Plug 'jelera/vim-javascript-syntax'

" Sublime Text style multiple selections
Plug 'terryma/vim-multiple-cursors'

" Mustache and handlebars mode for vim
Plug 'mustache/vim-mustache-handlebars'

" Paste in Vim with indentation adjusted to destination context
Plug 'sickill/vim-pasta'

" Toggle, display and navigate marks
Plug 'kshenoy/vim-signature'

" Seamless navigation between tmux panes and vim splits
Plug 'christoomey/vim-tmux-navigator'

" Add filetype glyphs (icons)
Plug 'ryanoasis/vim-devicons'

" Zoom in/out of windows
Plug 'troydm/zoomwintab.vim'

" Search Dash from vim
Plug 'rizzatti/dash.vim', { 'on': 'Dash' }

" Gotham colorscheme
Plug 'whatyouhide/vim-gotham'

" Vim Orgmode
Plug 'jceb/vim-orgmode', { 'for': 'org' }

" Increment dates, times, and more
Plug 'tpope/vim-speeddating'

" Insert or delete brackets, parens, quotes in pair
Plug 'jiangmiao/auto-pairs'

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
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#converter_default#use(['converter_relative_word'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#source('file_mru,file_rec,file_rec/async', 'converters', 'converter_relative_word')

" Restrict mru to display files for current project
call unite#custom#source(
  \ 'file_mru', 'matchers',
  \ ['matcher_project_files', 'matcher_fuzzy'])

call unite#custom#profile('default', 'context', {
  \ 'cursor_line_highlight' : 'CursorLine',
  \ 'start_insert': 1,
  \ 'winheight': 10,
  \ 'direction': 'botright',
  \ })

" Set up some custom ignores
call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
  \ 'ignore_pattern', join([
  \ '\.git/',
  \ 'tmp/',
  \ '.sass-cache',
  \ 'node_modules/',
  \ 'bower_components/',
  \ 'dist/',
  \ '.pyc',
  \ ], '\|'))

let g:unite_data_directory='~/.vim/.cache/unite'
let g:unite_source_history_yank_enable=1
let g:unite_source_rec_max_cache_files=5000
let g:unite_source_file_mru_limit=200
let g:unite_source_rec_async_command='ag --nocolor --nogroup --hidden -g ""'
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '-s -H --nocolor --nogroup --column'
let g:unite_source_grep_recursive_opt = ''
let g:unite_prompt='❯ '

nnoremap <C-f> :<C-u>Unite -buffer-name=files file_mru file_rec/async:!<CR>
nnoremap <leader>f :<C-u>Unite -no-split -no-resize -direction=topleft -buffer-name=mru file_mru<CR>
map <leader>y :<C-u>Unite -no-start-insert history/yank<CR>
nnoremap <leader>/ :<C-u>Unite grep:.<CR>

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_keymaps()

function! s:unite_keymaps()
  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)

  " Exit unite with Esc while in insert mode
  nmap <buffer> <Esc>   <Plug>(unite_exit)
  imap <buffer> <Esc>   <Plug>(unite_exit)
endfunction


""""""""""""""""""""""""""""""
" CTRL-P
""""""""""""""""""""""""""""""
" let g:ctrlp_working_path_mode = 'rw'
" let g:ctrlp_show_hidden = 1
" let g:ctrlp_max_height = 20

" let g:ctrlp_map = '<C-f>'
" map <C-b> :CtrlPBuffer<CR>

" let g:ctrlp_custom_ignore = 'public\|node_modules\|bower_components\|^\.DS_Store\|^\.git\|^\.coffee'

" let g:ctrlp_custom_ignore = {
"   \ 'dir':  '\v[\/]\.(git|hg|svn|sass-cache|node_modules|bower_components)$',
"   \ 'file': '\v\.(png|jpg|jpeg|gif|DS_Store|pyc)$',
"   \ 'link': '',
"   \ }


" only show files that are not ignored by git
" let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']


""""""""""""""""""""""""""""""
" NERDTree
""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "left"
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
  let g:airline_theme="gotham"
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
" yankstack
""""""""""""""""""""""""""""""

" Remove default key mappings
" let g:yankstack_map_keys = 0

" nmap <leader>p <Plug>yankstack_substitute_older_paste
" nmap <leader>P <Plug>yankstack_substitute_newer_paste


""""""""""""""""""""""""""""""
" vim-easymotion
""""""""""""""""""""""""""""""
map s <Plug>(easymotion-s)
map <leader>ss <Plug>(easymotion-s2)
map <leader><leader><leader> <Plug>(easymotion-prefix)

" match lower & upper case
let g:EasyMotion_smartcase = 1

let g:EasyMotion_use_smartsign_us = 1

map <leader>l <Plug>(easymotion-lineforward)
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)
map <leader>h <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion


""""""""""""""""""""""""""""""
" Neocomplete
""""""""""""""""""""""""""""""

" " Disable AutoComplPop.
" let g:acp_enableAtStartup = 0
" " Use neocomplete.
" let g:neocomplete#enable_at_startup = 1
" " Use smartcase.
" let g:neocomplete#enable_smart_case = 1
" " Set minimum syntax keyword length.
" let g:neocomplete#sources#syntax#min_keyword_length = 3
" let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" " <CR>: close popup and save indent.
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function()
"   return neocomplete#close_popup() . "\<CR>"
" endfunction

" " Enable omni completion.
" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags


""""""""""""""""""""""""""""""
" vim-fugitive
""""""""""""""""""""""""""""""
map <leader>gg :GitGutterToggle<CR>
map <leader>gs :Gstatus<CR>
set diffopt+=vertical


""""""""""""""""""""""""""""""
" Ultisnips
""""""""""""""""""""""""""""""
" Trigger configuration
let g:UltiSnipsExpandTrigger="<C-Space>"
let g:UltiSnipsJumpForwardTrigger="<C-n>"
let g:UltiSnipsJumpBackwardTrigger="<C-p>"


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

