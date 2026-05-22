vim.g.mapleader = ','

vim.o.ruler = true
vim.o.relativenumber = true
vim.wo.number = true
vim.wo.signcolumn = 'number'
vim.wo.wrap = false

-- Miscellaneous settings
vim.cmd('language en_US.utf-8')
vim.cmd("set encoding=utf8")
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')
vim.cmd('set noswapfile')
vim.cmd('set nocompatible')
vim.cmd('set mouse=a')
vim.cmd('set t_Co=256')
vim.cmd('set clipboard=unnamed')
vim.cmd('syntax on')
vim.cmd('set ignorecase')
vim.cmd('set nobackup')
vim.cmd('set diffopt=vertical')
vim.cmd('let &colorcolumn=join(range(81,999),",")')

-- Filetype Indentations
vim.cmd('autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4')
vim.cmd('autocmd FileType zig setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4')
vim.cmd('autocmd FileType zig setlocal commentstring=//\\ %s')
vim.cmd('autocmd Filetype c setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2')
vim.cmd('autocmd Filetype html setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2')
vim.cmd('autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4 autoindent')
vim.cmd('autocmd Filetype javascript setlocal tabstop=2 softtabstop=2 expandtab smarttab shiftwidth=2')
vim.cmd('autocmd Filetype rest setlocal tabstop=2 shiftwidth=2 softtabstop=2')
vim.cmd('autocmd Filetype json setlocal tabstop=2 shiftwidth=2 softtabstop=2')
vim.cmd('autocmd Filetype lua setlocal tabstop=2 shiftwidth=2 softtabstop=2')
vim.cmd('autocmd Filetype cmake setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4')
vim.cmd('autocmd Filetype cpp setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4')

-- Colorscheme tokyonight
vim.g.tokyonight_style = "dark"
vim.g.tokyonight_italic_functions = true
vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
vim.g.tokyonight_colors = { fg_gutter = "#7e8dcf" }
vim.cmd('colorscheme tokyonight')
