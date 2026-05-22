vim.g.mapleader = ','

local opts = {
    noremap = true,
    silent = true
}

-- General mappings
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>n', ':NERDTree<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>c', ':set cursorline!<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader><space>', ':noh<CR>', opts)

-- Easymotion mappings
vim.api.nvim_set_keymap('n', '<leader><leader>e',  '<Plug>(easymotion-jumptoanywhere)', opts)

-- Vim Tmux Runner
vim.api.nvim_set_keymap('n', '<leader>va', ':VtrAttachToPane<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>vl', ':VtrSendLinesToRunner<cr>', opts)
vim.api.nvim_set_keymap('v', '<leader>vl', ':VtrSendLinesToRunner<cr>', opts)

-- Fugitive mappings
vim.api.nvim_set_keymap('n', '<leader>gs', ':Git<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gb', ':Git blame<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gd', ':Git diff<CR>', opts)

-- Telescope
vim.api.nvim_set_keymap('n', '<C-p>', ':Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope buffers<CR>', opts)

-- Vim Rest Console
vim.api.nvim_set_keymap('n', '<leader>j', ':call VrcQuery()<CR>', opts)
