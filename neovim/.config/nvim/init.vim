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
Plug 'editorconfig/editorconfig-vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'hrsh7th/nvim-compe'
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
lua << EOF
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    nvim_lsp = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
EOF

verbose set completeopt?

""" Footnotes """

" [coc]: Configuration pulled from the example available here: https://github.com/neoclide/coc.nvim
" [dracula]: https://github.com/vim-airline/vim-airline-themes/blob/master/autoload/airline/themes/dracula.vim
" [move-blocks-visual]: https://vimrcfu.com/snippet/77
" [no-arrow-keys]: https://tylercipriani.com/vim.html
" [show-invisibles]: http://vimcasts.org/episodes/show-invisibles/

