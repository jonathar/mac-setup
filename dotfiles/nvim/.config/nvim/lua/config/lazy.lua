-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {

    { 'tpope/vim-surround' },
    { 'tpope/vim-unimpaired' },
    { 'tpope/vim-fugitive' },
    { 'diepm/vim-rest-console' },
    { 'preservim/nerdtree' },
    { 'easymotion/vim-easymotion' },
    { 'tpope/vim-commentary' },
    { 'tpope/vim-endwise' },
    { 'jvirtanen/vim-hcl' },

    -- TMUX plugins
    {
      'christoomey/vim-tmux-navigator',
      cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
      },
      keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      },
    },
    { 'christoomey/vim-tmux-runner' },

    -- Language plugins
    { 'fatih/vim-go' },
    { 'stephpy/vim-yaml' },
    { 'uarun/vim-protobuf' },

    -- Colorschemes
    { 'morhetz/gruvbox' },
    { 'EdenEast/nightfox.nvim' },
    { 'savq/melange' },
    { 'sainnhe/sonokai' },
    { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter" },

    -- LSP
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      config = function()
        require("mason").setup()
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = { "neovim/nvim-lspconfig" },
      config = function()
        require("mason-lspconfig").setup({
          ensure_installed = { "clangd", "gopls", "pylsp", "rust_analyzer", "terraformls", "zls" },
          handlers = {
            function(server_name)
              require("lspconfig")[server_name].setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
              })
            end,
          },
        })
      end,
    },

    -- Completion
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
      },
      config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>']      = cmp.mapping.confirm({ select = true }),
            ['<Tab>']     = cmp.mapping(function(fallback)
              if cmp.visible() then cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
              else fallback() end
            end, { 'i', 's' }),
            ['<S-Tab>']   = cmp.mapping(function(fallback)
              if cmp.visible() then cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then luasnip.jump(-1)
              else fallback() end
            end, { 'i', 's' }),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
          }, {
            { name = 'buffer' },
            { name = 'path' },
          }),
        })
      end,
    },

    -- UI
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'kyazdani42/nvim-web-devicons' },
    },
    {
      'nvim-telescope/telescope.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
    },

  },
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘', config = '🛠', event = '📅', ft = '📂',
      init = '⚙', keys = '🗝', plugin = '🔌', runtime = '💻',
      require = '🌙', source = '📄', start = '🚀', task = '📌', lazy = '💤 ',
    },
  },
})
