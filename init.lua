vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
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
vim.opt.showmode = false

-- save to clipboard
vim.opt.clipboard="unnamed"


-- R pipe
vim.keymap.set('i','<leader>m' ,'<space>%>%', {silent = true}) -- R Pipe

-- Prevent deleting from also copying
vim.keymap.set({'n', 'v'}, 'd', '"_d', { noremap = true })
vim.keymap.set('n', 'dd', '"_dd', { noremap = true })


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
{ "rose-pine/neovim", name = "rose-pine" },

-- hex color viwer
{'norcalli/nvim-colorizer.lua'},

-- auto pairs
{
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
},

-- send to tmux pane
{"jpalardy/vim-slime", name = "vim-slime",
config = function()
  vim.g.slime_target = "tmux"
end},

-- slime cells
{'klafyvel/vim-slime-cells', 
requires = {{'jpalardy/vim-slime', opt=true}},
  ft = {'r'},
  config=function ()
    vim.g.slime_target = "tmux"
    vim.g.slime_cell_delimiter = "^\\s*##"
    vim.g.slime_default_config = {socket_name="default", target_pane="1"}
    vim.g.slime_dont_ask_default = 1
    vim.g.slime_bracketed_paste = 1
    vim.g.slime_no_mappings = 1
    -- python
    vim.g.slime_python_ipython = 1
    -- general sending 
    vim.cmd([[
    nmap <leader>cv <Plug>SlimeConfig
    nmap <leader>cc <Plug>SlimeCellsSendAndGoToNext
    nmap <leader>j <Plug>SlimeCellsNext
    nmap <leader>k <Plug>SlimeCellsPrev
    ]])
  end
},
  
-- Latex 
{"lervag/vimtex",
init = function()
  vim.g.vimtex_view_method = 'zathura'
end},

-- telescope 
{"nvim-telescope/telescope.nvim"},
{"nvim-treesitter/nvim-treesitter"},
{"nvim-lua/plenary.nvim"},

-- statusline
{'nvim-lualine/lualine.nvim',
dependencies = {'nvim-tree/nvim-web-devicons'}
},


-- auto completion
{
"williamboman/mason.nvim",
"williamboman/mason-lspconfig.nvim",
"neovim/nvim-lspconfig",
},

-- Code formatter
{
  'stevearc/conform.nvim',
  opts = {},
},

-- file explorer
{
  'nvim-tree/nvim-tree.lua'
},


{
  "wojciech-kulik/xcodebuild.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("xcodebuild").setup({ 
      code_coverage = {
        enabled = true,
      },

    })

    vim.keymap.set("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Xcodebuild Logs" })
    vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
    vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" })
    vim.keymap.set("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
    vim.keymap.set("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run This Test Class" })
    vim.keymap.set("n", "<leader>X", "<cmd>XcodebuildPicker<cr>", { desc = "Show All Xcodebuild Actions" })
    vim.keymap.set("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
    vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildSelectTestPlan<cr>", { desc = "Select Test Plan" })
    vim.keymap.set("n", "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Code Coverage" })
    vim.keymap.set("n", "<leader>xC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", { desc = "Show Code Coverage Report" })
    vim.keymap.set("n", "<leader>xq", "<cmd>Telescope quickfix<cr>", { desc = "Show QuickFix List" })
  end,
},

{
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      swift = { "swiftlint" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged" }, {
      group = lint_augroup,
      callback = function()
        require("lint").try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>ml", function()
      require("lint").try_lint()
    end, { desc = "Lint file" })
  end,
},



}
local opts = {}


require("lazy").setup(plugins, opts)

-- theme with transparency
require("rose-pine").setup({
    variant = "auto", -- auto, main, moon, or dawn
    dark_variant = "main", -- main, moon, or dawn
    dim_inactive_windows = false,
    extend_background_behind_borders = true,

    enable = {
        terminal = true,
        legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
        migrations = true, -- Handle deprecated options automatically
    },

    styles = {
        bold = true,
        italic = true,
        transparency = false,
    },

    groups = {
        border = "muted",
        link = "iris",
        panel = "surface",

        error = "love",
        hint = "iris",
        info = "foam",
        note = "pine",
        todo = "rose",
        warn = "gold",

        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",

        h1 = "iris",
        h2 = "foam",
        h3 = "rose",
        h4 = "gold",
        h5 = "pine",
        h6 = "foam",
    },

    highlight_groups = {
        -- Comment = { fg = "foam" },
        -- VertSplit = { fg = "muted", bg = "muted" },
    },

    before_highlight = function(group, highlight, palette)
        -- Disable all undercurls
        -- if highlight.undercurl then
        --     highlight.undercurl = false
        -- end
        --
        -- Change palette colour
        -- if highlight.fg == palette.pine then
        --     highlight.fg = palette.foam
        -- end
    end,
})

vim.cmd("colorscheme rose-pine")
-- vim.cmd("colorscheme rose-pine-main")
-- vim.cmd("colorscheme rose-pine-moon")
-- vim.cmd("colorscheme rose-pine-dawn")


-- telescope minimal config
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- statusline setup
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {}, --'mode'
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {}, --'encoding'
    lualine_y = {'progress'},
    lualine_z = {} --'location'
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

require("colorizer").setup()

-- completion
require("mason").setup()

require("mason-lspconfig").setup {
    ensure_installed = {"clangd", "r_language_server", "gopls"},
}

require("lspconfig").r_language_server.setup{}
require("lspconfig").clangd.setup{}
require("lspconfig").gopls.setup{}

vim.diagnostic.config({
  signs = false
})

-- formatter
require("conform").setup({
 formatters_by_ft = {
    go = { "gofmt", },
    swift = { "swiftformat", },
  }
})

require("conform").setup({
  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 2000, lsp_format = "fallback" }
  end,
})



