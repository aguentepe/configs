" ---------------------------------------------------------------------
" --- Vundle ----------------------------------------------------------
" ---------------------------------------------------------------------
filetype off " required by Vundle

set rtp+=~/.config/nvim/bundle/Vundle.vim
set rtp+=~/.config/nvim
call vundle#begin('~/.config/nvim/bundle')

Plugin 'VundleVim/Vundle.vim'

" ----- Making Vim look good ------------------------------------------
Plugin 'altercation/vim-colors-solarized'
Plugin 'romainl/flattened'                "solarized without the bullshit
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Plugin 'blahgeek/neovim-colorcoder'
Plugin 'RRethy/vim-illuminate'
Plugin 'robertmeta/nofrils'

" ----- Vim as a programmer's text editor -----------------------------
Plugin 'tpope/vim-commentary'
"Plugin 'w0rp/ale'
Plugin 'ludovicchabant/vim-gutentags'
"Plugin 'majutsushi/tagbar'
"Plugin 'vim-scripts/a.vim'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'udalov/kotlin-vim'

" ----- Working with Git ----------------------------------------------
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

" ----- Other text editing features -----------------------------------
"Plugin 'Raimondi/delimitMate'
Plugin 'junegunn/goyo.vim'

" ----- Custom/Additional Vim functionality features ------------------
Plugin 'qpkorr/vim-bufkill'

" ----- man pages, tmux -----------------------------------------------
"Plugin 'jez/vim-superman'
"Plugin 'christoomey/vim-tmux-navigator'

" ---- Extras/Advanced plugins ----------------------------------------
" Highlight and strip trailing whitespace
"Plugin 'ntpeters/vim-better-whitespace'
" Easily surround chunks of text
Plugin 'tpope/vim-surround'
" Alignment and text filtering
Plugin 'godlygeek/tabular'
" Automaticall insert the closing HTML tag
Plugin 'HTML-AutoCloseTag'
" All the other syntax plugins I use
Plugin 'mattn/emmet-vim'
"Plugin 'suan/vim-instant-markdown'
"Plugin 'vim-script/h2cppx'

call vundle#end()

filetype plugin indent on " turn filetype back on after Vundle

" ---------------------------------------------------------------------
" --- General settings ------------------------------------------------
" ---------------------------------------------------------------------
set number                     " show linenumbers infront of every line
set relativenumber             " show linenumber of currentline and realtive numbers on others
"set tabstop=8 softtabstop=4 shiftwidth=4 expandtab
set tabstop=4 softtabstop=-1 shiftwidth=4
set clipboard=unnamedplus
set hlsearch incsearch
set ff=unix
set ignorecase smartcase
set splitright splitbelow
set mouse=a                    " all mouse modes
set path+=**
set list lcs=tab:\|\           " from https://github.com/Yggdroot/indentLine for vertical lines at each indentation level

syntax enable                  " syntax highlighting

" We need this for plugins like Syntastic and vim-gitgutter which put symbols
" in the sign column.
hi clear SignColumn

nmap  :w<CR>
command Rc tabe $HOME/.config/nvim/init.vim
nmap <leader>d :bd<CR>

" ---------------------------------------------------------------------
" --- AGD Specific settings -------------------------------------------
" ---------------------------------------------------------------------
if $AGD == "RUNNING"
    "set makeprg=(cd\ build\ &&\ make\ -j\ 4)
    set makeprg=(cd\ build\ &&\ make)
else
    set makeprg=make\ -j\ 4
endif

" If AGD is running save the AGD Session and quit
function! QuitAGD ()
    if $AGD == "RUNNING"
        mks! $PROJECTDIR/.agd/Session.vim
    endif
    qa
endfunction
command Qa call QuitAGD()

" Map CMake build and execute commands for AGD
function! ConfigureAGD ()
    if $AGD == "RUNNING"
        !(cd build && cmake -DHBRS_MPL_ENABLE_TESTS=ON -DCMAKE_BUILD_TYPE=Debug ..)
    endif
endfunction
command Cmake call ConfigureAGD()
nmap <leader>m :make<CR>
function! ExecuteAGD ()
    if $AGD == "RUNNING"
        !(cd build && make -j 4) && make test
    endif
endfunction
nmap <leader>r :call ExecuteAGD()<CR>

" ---------------------------------------------------------------------
" ----- Plugin-Specific Settings --------------------------------------
" ---------------------------------------------------------------------

" Set the colorscheme
set background=dark
 let g:solarized_termtrans = 0
colorscheme flattened_dark
" call togglebg#map("<leader>b")


" ----- bling/vim-airline settings -----
" Always show statusbar
set laststatus=2

" Fancy arrow symbols, requires a patched font
" To install a patched font, run over to
"     https://github.com/abertsch/Menlo-for-Powerline
" Finally, uncomment the next line
let g:airline_powerline_fonts = 1

" Show PASTE if in paste mode
let g:airline_detect_paste = 1

" Show airline for tabs too
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" Enable airline for ale
let g:airline#extensions#ale#enabled = 1

" Use the solarized theme for the Airline status bar
let g:airline_theme = 'solarized_flood'


" ----- airblade/vim-gitgutter settings -----
" In vim-airline, only display "hunks" if the diff is non-zero
set updatetime=100
let g:airline#extensions#hunks#non_zero_only = 1


" ----- Raimondi/delimitMate settings -----
let delimitMate_expand_cr = 1
augroup mydelimitMate
  au!
  au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
  au FileType tex let b:delimitMate_quotes = ""
  au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
  au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END


" ----- jez/vim-superman settings -----
" better man page support
" noremap K :SuperMan <cword><CR>


" ----- vim-script/h2cppx settings -----
let g:h2cppx_postfix = 'cc'


" ----- junegunn/fzf.vim settings -----
nmap <leader>t :Buffers<CR>
nmap <leader>f :Files<CR>


" ----- blahgeek/neovim-colorcoder -----
"let g:colorcoder_enable_filetypes = ['cpp', 'hpp']
set termguicolors

"nmap <leader>c :ColorcoderUpdate!<CR>


" ----- SirVer/UltiSnips -----
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let g:UltiSnipsSnippetsDir="~/.config/nvim/snip"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "snip"]


" ----- mattn/emmet-vim -----
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall


" ----- qpkorr/vim-bufkill -----
nmap <leader>D :BD<CR>


" ----- junegunn/goyo.vim -----
nmap <leader>g :Goyo<CR>
