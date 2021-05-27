" All plugin srcs can be found in the plugin names themselves
" For example Plug 'scrooloose/nerdtree' lives at
" https://github.com/scrooloose/nerdtree
" See footnotes for relevant links and notes

""" Plugins """

" If vim-plug isn't installed, we can do that on the first run?
if empty(glob('$HOME/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Where do our plugins live?
call plug#begin('$HOME/.local/share/nvim/plugged')

" What plugins do we want to install?
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'editorconfig/editorconfig-vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'hrsh7th/nvim-compe'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Let's start up the plugin system
call plug#end()

""" Quality of Life """

" Can you show me some line numbers on the left hand side?
set number
" Can I see results, live while I'm performing a search?
set incsearch
" I'm blind. Can you highlight search results for me?
set hlsearch

" How can I use J and K to move blocks up and down in visual mode?
" [footnotes#move-blocks-visual]
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" How can we automatically detect filetype and set the appropriate level of
" indentation?
filetype plugin indent on

" Can we set a tab to be 2 spaces wide?
set tabstop=2

" Can we indent by 2 spaces when using `>`?
set shiftwidth=2

" Can we get the TAB key to insert 2 spaces?
set expandtab

" Can we get the TAB key to insert 4 spaces for Python files? PEP8 is a nice idea
autocmd Filetype python setlocal ts=4 sw=4 sts=4

" TextMate has a nice way of showing invisibles. Can we have that too?
" [footnotes#show-invisibles]
set listchars=tab:▸\ ,eol:¬

" Can we toggle invisibles on and off using `\ + l` in NORMAL mode?
nmap <leader>l :set list!<CR>

" Can we get a list of files on the left hand side by hitting `Ctrl + n`?
map <C-n> :NERDTreeToggle<CR>

" How can I see invisible files by default in NERDTree?
let NERDTreeShowHidden=1

""" Get better at using vim """

" I really need to learn Vim keybindings. Can we disable the arrow keys, so
" that only hjkl are usable in INSERT and NORMAL mode?
" [footnotes#no-arrow-keys]
inoremap <Up> <NOP>
noremap <Up> <NOP>
inoremap <Down> <NOP>
noremap <Down> <NOP>
inoremap <Left> <NOP>
noremap <Left> <NOP>
inoremap <Right> <NOP>
noremap <Right> <NOP>

""" Makin' things look nice """

" Don't you think Dracula is a nice theme?
" [footnote#dracula]
syntax on
let g:airline_theme='dracula'

""" COC (autocompleter) configuration [footnote#coc] """

" Can we press TAB to move through COC's autocompletion list?
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

" Prefer Python 3
let pyx=3
let g:python3_host_prog='$HOME/.asdf/shims/python3'

""" NERDTree """
nnoremap <C-t> :NERDTreeToggle<CR>

""" LSP configuration """
lua << EOF
require'lspconfig'.bashls.setup{}
require'lspconfig'.gopls.setup{}
require'lspconfig'.jsonls.setup{}
require'lspconfig'.pyright.setup{}
require'lspconfig'.yamlls.setup{}
EOF

""" nvim-compe """
set completeopt=menuone,noselect

""" Footnotes """

" [coc]: Configuration pulled from the example available here: https://github.com/neoclide/coc.nvim
" [dracula]: https://github.com/vim-airline/vim-airline-themes/blob/master/autoload/airline/themes/dracula.vim
" [move-blocks-visual]: https://vimrcfu.com/snippet/77
" [no-arrow-keys]: https://tylercipriani.com/vim.html
" [show-invisibles]: http://vimcasts.org/episodes/show-invisibles/

