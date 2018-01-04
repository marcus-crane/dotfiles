" All plugin srcs can be found in the plugin names themselves
" For example Plug 'scrooloose/nerdtree' lives at
" https://github.com/scrooloose/nerdtree

""" Plugins """

" Load vim-plug or install it on first run if you don't have it
if empty(glob('$HOME/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" This is where plugins will live
call plug#begin('$HOME/.local/share/nvim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'mhartington/oceanic-next'
Plug 'vim-airline/vim-airline'

" Initialize the plugin system
call plug#end()

""" Quality of Life """

" Show the line numbers in the left gutter
set number
" Show matches while searching
set incsearch
" Enable search highlighting
set hlsearch

" Rebind J and K to move blocks up and down in visual mode
" src: https://vimrcfu.com/snippet/77
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Load filetype detection and indentation
filetype plugin indent on
" Show existing tab as having a width of 4 spaces
set tabstop=4
" Use 4 spaces when indenting with `>`
set shiftwidth=4
" Insert 4 spaces when pressing tab
set expandtab

" src: http://vimcasts.org/episodes/show-invisibles/
" Set invisibles representation to be the same as TextMate
set listchars=tab:▸\ ,eol:¬
" Toggle invisibles using `\ + l` in NORMAL mode
nmap <leader>l :set list!<CR>

" Activate NERDTree with `Ctrl + n`
map <C-n> :NERDTreeToggle<CR>

""" Get better at using vim """

" src: https://tylercipriani.com/vim.html
" Disable arrow keys, forcing hjkl only in both INSERT and NORMAL modes
inoremap <Up> <NOP>
noremap <Up> <NOP>
inoremap <Down> <NOP>
noremap <Down> <NOP>
inoremap <Left> <NOP>
noremap <Left> <NOP>
inoremap <Right> <NOP>
noremap <Right> <NOP>

""" Makin' things look nice """

" src: https://github.com/mhartington/oceanic-next
" Theme -> Oceanic Next
syntax on
let g:airline_theme='oceanicnext'
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
colorscheme OceanicNext
