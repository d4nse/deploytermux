let mapleader = ";"

" Search
set hlsearch			        " Highlight search
set incsearch			        " Search all occurances

" Indentation
set tabstop=4			        " Sets tab size to 4 spaces
set softtabstop=4		        "
set shiftwidth=4		        "
set expandtab			        " Convert tabs into spaces
set autoindent			        " Autoindent code

" Misc
syntax on			            " Enable syntax highlighting
set wildmode=longest,list,full  " Enable autocompletion, ctrl+n to activate
set encoding=utf-8	            " Set encoding
set fileformat=unix		        " File formatting
set number			            " Enable line numbers
set clipboard=unnamedplus	    " Enables system clipboard
if has('termguicolors')
    set termguicolors           " ALL THE COLORS ALL OF THEM ALL
endif


" Split window
set splitbelow splitright	    " Split windows to right instead of down
map <C-h> <C-w>h
map <C-l> <C-w>l

" Remaps
nnoremap <silent> <C-t> :tabnew<CR>
nnoremap <leader>q :q<CR>
nnoremap j gj
nnoremap k gk
map <C-j> gT
map <C-k> gt

" Automation
autocmd BufWritePre * %s/\s\+$//e   " Delete trailing whitespaces on save
"autocmd BufWritePre * :normal gg=G  " Reindent file on save
