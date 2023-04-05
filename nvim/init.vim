" ----- vim-plug ------------------------------------------------------
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin()
" ----- Colorschemes --------------------------------------------------
Plug 'altercation/vim-colors-solarized'
" solarized without the nonsense
Plug 'romainl/flattened'
Plug 'robertmeta/nofrils'
Plug 'EdenEast/nightfox.nvim'
" Plug 'dylanaraps/wal.vim'
Plug 'tomasiser/vim-code-dark'
Plug 'AlphaTechnolog/pywal.nvim', { 'as': 'pywal' }

" ----- Making Vim look good ------------------------------------------
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Highlight words based on their hashing
" Plug 'blahgeek/neovim-colorcoder'
" Vim plugin for automatically highlighting other uses of the current word under the cursor
Plug 'RRethy/vim-illuminate'
" Preview colours in source code while editing
Plug 'ap/vim-css-color'

" ----- Vim as a programmer's text editor -----------------------------
Plug 'tpope/vim-commentary'
" Asynchronous Lint Engine
Plug 'w0rp/ale'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
" Alternate Files quickly (.c --> .h etc)
" Plug 'vim-scripts/a.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'SirVer/ultisnips'
" default snippets
Plug 'honza/vim-snippets'
Plug 'udalov/kotlin-vim'
Plug 'Tetralux/odin.vim'
Plug 'elkowar/yuck.vim'
" Debugging
" Plug 'puremourning/vimspector'
" Intellisense Engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Asynchronous build and test dispatcher
Plug 'tpope/vim-dispatch'
Plug 'gentoo/gentoo-syntax'
Plug 'preservim/nerdtree'

" ----- Working with Git ----------------------------------------------
" A Vim plugin which shows a git diff in the sign column
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" ----- Other text editing features -----------------------------------
Plug 'junegunn/goyo.vim'

" ----- Custom/Additional Vim functionality features ------------------
Plug 'qpkorr/vim-bufkill'

" ---- Extras/Advanced plugins ----------------------------------------
" enable repeating supported plugin maps with "."
Plug 'tpope/vim-repeat'
" Easily surround chunks of text
Plug 'tpope/vim-surround'
"use CTRL-A/CTRL-X to increment dates, times, and more
Plug 'tpope/vim-speeddating'
" Alignment and text filtering
Plug 'godlygeek/tabular'
Plug 'mattn/emmet-vim'
" neovim in your browser
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
call plug#end()


" --- General settings ------------------------------------------------
set title
set number relativenumber
set tabstop=8 softtabstop=4 shiftwidth=4 expandtab
" set tabstop=4 softtabstop=-1 shiftwidth=4 noexpandtab
set clipboard=unnamedplus
set ignorecase smartcase
set splitright splitbelow
set mouse=a                    " all mouse modes
set path+=**
set list listchars=tab:⎸\ ,trail:$,nbsp:+

syntax enable                  " syntax highlighting

" We need this for plugins like Syntastic and vim-gitgutter which put symbols
" in the sign column.
hi clear SignColumn

nmap  :w<CR>
command Rc tabe $HOME/.config/nvim/init.vim
nmap <leader>d :bd<CR>

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" --- Folding -----------------------------------

au FileType c call FoldCurlyBrackets()
au FileType cc call FoldCurlyBrackets()
au FileType cpp call FoldCurlyBrackets()
au FileType c++ call FoldCurlyBrackets()
au FileType odin call FoldCurlyBrackets()
au FileType markdown call FoldMD()
function FoldCurlyBrackets()
	setlocal foldcolumn=2
	setlocal foldmethod=expr
	setlocal fillchars=fold:\ 
	" This will make a fold out of indented paragraphs separated by blank lines and nonindented blocks:
	setlocal foldexpr=getline(v:lnum)=~'^\\s*$'&&getline(v:lnum+1)=~'^\\s\\+\\S'?'>2':getline(v:lnum)=~'^\\s\\+\\S'?'=':getline(v:lnum)=~'^.*{[^}]*$'?1:getline(v:lnum)=~'^}[^{]*$'?'<1':'='

	setlocal foldtext=FoldText()
	function! FoldText()
		let l:lpadding = &fdc
		redir => l:signs
			execute 'silent sign place buffer='.bufnr('%')
		redir End
		let l:lpadding += l:signs =~ 'id=' ? 2 : 0

		if (&number)
			let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
		elseif (&relativenumber)
			let l:lpadding += max([&numberwidth, strlen(v:foldstart - line('w0')), strlen(line('w$') - v:foldstart), strlen(v:foldstart)]) + 1
		endif

		let l:info = ' (' . (v:foldend - v:foldstart) . ')'
		let l:infolen = strlen(substitute(l:info, '.', 'x', 'g'))
		let l:width = winwidth(0) - l:lpadding - l:infolen

		if (getline(v:foldstart)=~'^\s*$')
			" let l:start = repeat(' ', (v:foldlevel - 1) * &shiftwidth)
			let l:start = substitute(substitute(getline(v:foldstart)=~'^\s*$'?getline(v:foldstart+1):getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g'), repeat(' ', &tabstop), '⎸' . repeat(' ', &tabstop-1), 'g')
			let l:end = substitute(substitute(getline(v:foldend), '\t', repeat(' ', &tabstop), 'g'), '^\s*', '', 'g')

			return l:start . repeat(' ', l:width + (l:infolen - 5) - strlen(substitute(l:start, ".", "x", "g")) - strlen(substitute(l:end, ".", "x", "g"))) . l:end . repeat(' ', 5 - l:infolen) . l:info
		else
			" expand tabs
			let l:start = substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')
			let l:end = substitute(substitute(getline(v:foldend), '\t', repeat(' ', &tabstop), 'g'), '^\s*', '', 'g')

			let l:separator = ' … '
			let l:separatorlen = strlen(substitute(l:separator, '.', 'x', 'g'))
			let l:start = strpart(l:start , 0, l:width - strlen(substitute(l:end, '.', 'x', 'g')) - l:separatorlen)
			let l:text = l:start . l:separator . l:end
		endif

		return l:text . repeat(' ', l:width - strlen(substitute(l:text, ".", "x", "g"))) . l:info
	endfunction
endfunction
function FoldMD()
	setlocal foldcolumn=2
	setlocal foldmethod=expr
	setlocal fillchars=fold:\ 
	" setlocal foldexpr=getline(v:lnum)=~'^##'?1:getline(v:lnum)=~'^#'?0:getline(v:lnum-1)=~'^#'?'a1':'='
	setlocal foldexpr=getline(v:lnum)=~'^##'?'>2':getline(v:lnum)=~'^#'?'>1':'='
endfunction

" --- Development Specific settings -----------------------------------
set makeprg=make\ -j\ 8
nmap <leader>m :make<CR>

" Map CMake build and execute commands
command Cmake !(mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=Debug ..)
nmap <leader>r !(cd build && make -j 8) && make test


" ----- Plugin-Specific Settings --------------------------------------

" Set the colorscheme
" set background=dark
" let g:solarized_termtrans = 0
" colorscheme flattened_dark
" colorscheme terafox
" colorscheme wal
colorscheme pywal
" call togglebg#map("<leader>b")


" ----- vim-airline/vim-airline settings -----

" Fancy arrow symbols, requires a patched font
" To install a patched font, run over to
"     https://github.com/abertsch/Menlo-for-Powerline
let g:airline_powerline_fonts = 1

" Show PASTE if in paste mode
let g:airline_detect_paste = 1

" Show airline for tabs too
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" Enable airline for ale
" let g:airline#extensions#ale#enabled = 1

" Set a theme for the Airline status bar
" let g:airline_theme = 'solarized_flood'


" ----- airblade/vim-gitgutter settings -----
" In vim-airline, only display "hunks" if the diff is non-zero
set updatetime=100
let g:airline#extensions#hunks#non_zero_only = 1


" ----- tpope/vim-fugitive settings -----
nmap <leader>w :Gwrite<CR>
nmap <leader>c :G commit<CR>


" ----- junegunn/fzf.vim settings -----
nmap <leader>t :Buffers<CR>
nmap <leader>f :GitFiles<CR>


" ----- blahgeek/neovim-colorcoder -----
"let g:colorcoder_enable_filetypes = ['cpp', 'hpp']
" set termguicolors

"nmap <leader>c :ColorcoderUpdate!<CR>


" ----- SirVer/UltiSnips -----
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-enter>"
let g:UltiSnipsJumpForwardTrigger="<c-enter>"
let g:UltiSnipsJumpBackwardTrigger="<c-s-enter>"

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


" ----- puremourning/vimspector -----
let g:vimspector_enable_mappings = 'HUMAN'


" ----- neoclide/coc.nvim -----
" Some servers have issues with backup files, see #649.
set nowritebackup
set cmdheight=2
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
"
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" ----- glacambre/firenvim settings -----
if exists("g:started_by_firenvim")
    let g:airline#extensions#tabline#enabled = 0
    autocmd BufRead * set laststatus=0
endif
