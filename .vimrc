" Keep 100 items in the history.
set history=100

" Show the cursor position.
set ruler

" Show incomplete commands.
set showcmd

" Shows a menu when using tab completion.
set wildmenu

" Set minimal number of screen lines to keep above and below the cursor.
set scrolloff=5

" Disable highlight search.
set noshlsearch

" While typing a search command, show where the pattern,
set incsearch

" Ignore case when searching.
set ignorecase

" Override the 'ignorecase' option if the search pattern contains upper case characters.
set smartcase

" Better line wrap, last word of the line will not be be break to next line.
set linebreak

" Enable auto indent.
set autoindent

" Enable smart indent.
set smartindent

" Indicate dark backgroung.
set background=dark

" Multiple Windows, remapped Ctrl-W hjkl to Ctrl-hjkl
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
