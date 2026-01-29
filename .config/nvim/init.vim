colorscheme habamax
set number
set hlsearch

set tabstop=4
set shiftwidth=4

set expandtab " use spaces instead of tabs
set smarttab

augroup RestoreCursorShapeOnExit
	autocmd!
	autocmd VimLeave * set guicursor=a:hor20
augroup END
