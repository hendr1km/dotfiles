vim.cmd("set expandtab")
vim.cmd("set tabstop=3")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.g.mapleader = ',' 
vim.g.maplocalleader = ',' -- change local leader to a comma (',')

vim.opt.number = true -- Show line numbers
vim.opt.autoindent = true -- Automatically indent new lines
vim.opt.autowrite = true -- Automatically write files when switching buffers
vim.opt.autoread = true -- Automatically reload files changed outside of vim
vim.opt.cursorline = true -- Highlight the line the cursor is on
vim.o.termguicolors = true
vim.opt.autochdir = false
vim.opt.swapfile = false

-- save to clipboard
vim.opt.clipboard="unnamed"

-- R pipe
vim.keymap.set('i','<leader>m' ,'<space>%>%', {silent = true}) -- R Pipe


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- lazy nvim
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- theme 
local plugins = {
{"neanias/everforest-nvim", name = "everforest", priority = 1000},

-- send to tmux pane
{"jpalardy/vim-slime", name = "vim-slime",
config = function()
  vim.g.slime_target = "tmux"
end},

-- Latex 
{"lervag/vimtex",
init = function()
  vim.g.vimtex_view_method = 'zathura'
end},

-- telescope 
{"nvim-telescope/telescope.nvim"},
{"nvim-treesitter/nvim-treesitter"},
{"nvim-lua/plenary.nvim"},

}
local opts = {}


require("lazy").setup(plugins, opts)

-- theme with transparency
require("everforest").setup({
transparent_background_level = 1 
})

-- theme
vim.cmd.colorscheme "everforest"

-- telescope minimal config
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


