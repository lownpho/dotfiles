" ============================================================================
" SETTINGS
" ============================================================================

set mouse=a
set number relativenumber
set cursorline
set tabstop=4 shiftwidth=4
set expandtab
set smartindent
set noshowmode
set signcolumn=yes
set breakindent
set undofile
set undodir=~/.vim/undo
set ignorecase smartcase
set updatetime=250
set timeoutlen=500
set splitright splitbelow
" set inccommand=split           " Show live substitutions in split (Vim 9.2+)
set list
set listchars=tab:»\ ,trail:·,nbsp:␣
set scrolloff=10
set wildmenu
set wildmode=longest,list,full
set hlsearch incsearch
set statusline=%f\ %h%m%r%=[%l:%c]\ %p%%
set laststatus=2

if !isdirectory(expand('~/.vim/undo'))
  call mkdir(expand('~/.vim/undo'), 'p')
endif

" ============================================================================
" LEADER KEY & KEYMAPS
" ============================================================================

let mapleader = ' '

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <M-Up> :resize +2<CR>
nnoremap <M-Down> :resize -2<CR>
nnoremap <M-Left> :vertical resize -2<CR>
nnoremap <M-Right> :vertical resize +2<CR>

nnoremap <leader>nh :nohlsearch<CR>

" System clipboard
vnoremap <leader>y "+y
nnoremap <leader>p "+p

" Format entire buffer with gq (built-in, uses formatprg if set)
" This can cause issues when not configure, watch out...
nnoremap <leader>f gggqG

" Buffer navigation because I miss telescope
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bl :buffers<CR>

" Jump to definition (ctags - requires ctags to be installed)
nnoremap gd <C-]>
nnoremap gD <C-W><C-]>

" Diagnostics-like navigation with quickfix
nnoremap [d :cprevious<CR>
nnoremap ]d :cnext<CR>

" ============================================================================
" COLORSCHEME (Fallback to built-in)
" ============================================================================

" Use retrobox colorscheme if available, otherwise default
silent! colorscheme retrobox
set background=dark

" Simple highlight customizations
highlight CursorLine ctermbg=237 guibg=#3a3a3a
highlight LineNr ctermfg=244 guifg=#808080
highlight SignColumn ctermbg=235 guibg=#262626

" ============================================================================
" AUTOCMDS
" ============================================================================

if has('autocmd')
  filetype plugin indent on

  " Auto-reload vimrc when changed
  augroup vimrc
    autocmd!
    autocmd BufWritePost ~/.vimrc source ~/.vimrc
  augroup END

  " Remove trailing whitespace on save
  augroup whitespace
    autocmd!
    autocmd BufWritePre * :%s/\s\+$//e
  augroup END
endif

