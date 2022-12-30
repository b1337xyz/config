syntax on
filetype indent plugin on
set statusline=%<%f\ %m%h%r%=%-8.(%l,%c,%L%)\ %P\ %#warningmsg#
set switchbuf=usetab
set nocompatible
set hidden
set wildmenu
set showcmd
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent 
set nostartofline
set ruler
set laststatus=2
set visualbell
set mouse=a
set cmdheight=1
set number
set relativenumber
set background=dark
set notimeout ttimeout ttimeoutlen=200
set pastetoggle=<F11>
set shiftwidth=4
set softtabstop=4
set expandtab
set cursorline
set clipboard=unnamedplus
set undofile
set scrolloff=8
set incsearch
set nohlsearch

noremap <F4> :set hlsearch! hlsearch?<CR>
map Ee :FZF ~/.scripts<CR>

autocmd BufEnter * :syntax sync fromstart
autocmd BufWritePost */glava/* !~/.config/glava/restart
autocmd BufWritePost .tmux.conf !tmux source-file ~/.tmux.conf \; display "Reloaded"
autocmd BufWritePost Xresources !xrdb load %
autocmd BufWritePost dunstrc !~/.scripts/shell/dunst/reload.sh
autocmd BufWritePost */i3/* !i3-msg reload
autocmd BufWritePost */i3blocks/config !i3-msg restart
autocmd BufWritePost */X11/themes/* !xrdb load ~/.config/X11/Xresources
autocmd BufWritePost */alacritty/themes/*.yml !touch -m ~/.config/alacritty/*.yml
autocmd BufNewFile,BufRead *.py set colorcolumn=80
autocmd BufNewFile,BufRead .bashrc,.bash_aliases,.profile set filetype=bash
autocmd BufNewFile,BufRead lfrc set syntax=config
autocmd BufNewFile,BufRead */i3/* set syntax=i3config
autocmd BufNewFile,BufRead ~/.config/X11/themes/* set syntax=xdefaults
autocmd BufNewFile *.sh 0r     $XDG_CONFIG_HOME/nvim/templates/skeleton.sh
autocmd BufNewFile *.py 0r     $XDG_CONFIG_HOME/nvim/templates/skeleton.py
autocmd BufNewFile *.html 0r   $XDG_CONFIG_HOME/nvim/templates/skeleton.html
autocmd BufNewFile *.css 0r    $XDG_CONFIG_HOME/nvim/templates/skeleton.css

call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-syntastic/syntastic'
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color'
Plug 'nvie/vim-flake8'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Colorschemes
Plug 'Mofiqul/dracula.nvim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'EdenEast/nightfox.nvim'
Plug 'ellisonleao/gruvbox.nvim'
call plug#end()

colorscheme tokyonight

hi Normal guibg=NONE ctermbg=NONE
" hi ColorColumn ctermbg=236
" hi LineNr ctermfg=7 ctermbg=NONE
" hi CursorLine cterm=NONE ctermbg=233
" hi CursorLine term=underline
" hi Visual ctermfg=1 ctermbg=233

autocmd FileType python map <buffer> <F8> :call flake8#Flake8()<CR>

let g:deoplete#enable_at_startup = 1
let g:autoclose_on = 0
let g:python_highlight_all = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { 'passive_filetypes': ['python'] }
let g:flake8_quickfix_height = 8

" https://vim.fandom.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END
