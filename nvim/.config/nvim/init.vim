" All plugin srcs can be found in the plugin names themselves
" For example Plug 'scrooloose/nerdtree' lives at
" https://github.com/scrooloose/nerdtree
" See footnotes for relevant links and notes

""" Plugins """

" Load vim-plug or install it on first run if you don't have it
if empty(glob('$HOME/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" This is where plugins will live
call plug#begin('$HOME/.local/share/nvim/plugged')

Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nathangrigg/vim-beancount'

" Initialize the plugin system
call plug#end()

""" Quality of Life """

" Show the line numbers in the left gutter
set number
" Show matches while searching
set incsearch
" Enable search highlighting
set hlsearch

" Rebind J and K to move blocks up and down in visual mode [footnotes#move-blocks-visual]
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Load filetype detection and indentation
filetype plugin indent on

" Show existing tab as having a width of 2 spaces
set tabstop=2

" Use 2 spaces when indenting with `>`
set shiftwidth=2

" Insert 2 spaces when pressing tab
set expandtab

" Insert 4 spaces for Python files to match PEP8
autocmd Filetype python setlocal ts=4 sw=4 sts=4

" Set invisibles representation to be the same as TextMate [footnotes#show-invisibles]

set listchars=tab:▸\ ,eol:¬
" Toggle invisibles using `\ + l` in NORMAL mode
nmap <leader>l :set list!<CR>

" Activate NERDTree with `Ctrl + n`
map <C-n> :NERDTreeToggle<CR>

""" Get better at using vim """

" Disable arrow keys, forcing hjkl only in both INSERT and NORMAL modes [footnotes#no-arrow-keys]
inoremap <Up> <NOP>
noremap <Up> <NOP>
inoremap <Down> <NOP>
noremap <Down> <NOP>
inoremap <Left> <NOP>
noremap <Left> <NOP>
inoremap <Right> <NOP>
noremap <Right> <NOP>

""" Makin' things look nice """

" Theme -> Dracula [footnote#dracula]
syntax on
let g:airline_theme='dracula'

""" COC (autocompleter) configuration [footnote#coc] """

set updatetime=300

" Use tab to trigger completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c_space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

""" Beancount """
" Align commodities anytime a period is inserted
autocmd FileType beancount inoremap . .<C-\><C-O>:AlignCommodity<CR>

""" Footnotes """

" [coc]: Configuration pulled from the example available here: https://github.com/neoclide/coc.nvim
" [dracula]: https://github.com/vim-airline/vim-airline-themes/blob/master/autoload/airline/themes/dracula.vim
" [move-blocks-visual]: https://vimrcfu.com/snippet/77
" [no-arrow-keys]: https://tylercipriani.com/vim.html
" [show-invisibles]: http://vimcasts.org/episodes/show-invisibles/

