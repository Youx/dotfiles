local use = require('packer').use

-- {{{ Packer bootstrap
--
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

-- }}}

require('packer').startup({function()
    use 'wbthomason/packer.nvim'   -- Package manager
    -- {{{ Language plugins
    use {                                           -- Configurations for Nvim LSP
        'neovim/nvim-lspconfig',
        config = function()
            require('lsp')
        end
    }
    use { -- Rust LSP tools
        'simrat39/rust-tools.nvim',
        config = function()
            require('rust-tools-config')
        end
    }
    use 'rust-lang/rust'
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup()
        end
    }
    -- DEPRECATED use 'nvim-lua/completion-nvim'
    -- DEPRECATED Plug 'nvim-lua/diagnostic-nvim'
    use 'nvim-lua/plenary.nvim'
    use 'mfussenegger/nvim-dap'
    use({
        'glepnir/galaxyline.nvim',
        branch = 'main',
        config = function()
            require('bubbles')
        end,
        requires = {
            'kyazdani42/nvim-web-devicons',
            'yamatsum/nvim-nonicons'
        },
    })
    -- {{{ Git
    use 'tpope/vim-fugitive'
    use {
      'lewis6991/gitsigns.nvim',
      config = function()
          require('gitsigns').setup()
      end
    }
    -- }}}
    use {       -- Color scheme
        'rakr/vim-one',
        config = function()
            vim.g.one_allow_italics = 1
            vim.cmd('set background=dark')
            vim.cmd('colorscheme one')
        end
    }
    use 'mhinz/vim-startify' -- Startup screen
    use {                    -- Search anything
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = {
            {'nvim-lua/plenary.nvim'},
            {'sharkdp/fd'},
            {'nvim-treesitter/nvim-treesitter'},
            {'kyazdani42/nvim-web-devicons'}
        }
    }
    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {
            }
        end
    }
    use {                     -- Tabs per buffer
        'akinsho/bufferline.nvim',
        tag = "v2.*",
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require('bufferline').setup {
                options = {
                    diagnostics = 'nvim_lsp'
                }
            }
        end
    }
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons',
        },
        config = function()
            require('nvim-tree').setup()
        end
    }
    use 'vim-denops/denops.vim'

    -- First setup
    if packer_bootstrap then
        require('packer').sync()
    end
end,
config = {
    display = {
        open_fn = require('packer.util').float,
    }
}})

vim.cmd [[
syntax on
set nocompatible
set showmatch
set hlsearch
set tabstop=4
set expandtab
set shiftwidth=4
set autoindent
set mouse=a
]]
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.g.mapleader = ' '
vim.keymap.set('n', '<Space>', '<Nop>')
vim.keymap.set('n', '<F1>', vim.lsp.buf.hover)
vim.keymap.set('n', '<F2>', vim.lsp.buf.rename)
vim.keymap.set('n', '<F5>', '<cmd>NvimTreeToggle<cr>')

require('which-key').register({
    s = {
        name = 'Session...',
        l = { "<cmd>SLoad<cr>", "Load" },
        s = { "<cmd>SSave<cr>", "Save" },
        c = { "<cmd>SClose<cr>", "Close" },
        d = { "<cmd>SDelete<cr>", "Delete" },
    },
    f = {
        name = "Find...",
        f = { "<cmd>Telescope find_files<cr>", "Find File" },
        g = { "<cmd>Telescope live_grep<cr>", "Grep current file" },
        b = { "<cmd>Telescope buffers<cr>", "Buffers" },
        t = { "<cmd>Telescope help_tags<cr>", "Tags" },
        h = { "<cmd>Telescope oldfiles<cr>", "History" },
    },
    g = {
        name = "Git...",
        b = { "<cmd>Git blame<cr>", "Blame" },
        l = { "<cmd>Git log<cr>", "Log" },
        d = { "<cmd>Git diff<cr>", "Diff" },
        m = { "<cmd>Git mergetool<cr>", "Merge tool" },
    },
    l = {
        name = "LSP...",
        g = {
            name = "Go to...",
            d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Definition" },
            D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Declaration" },
            i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Implementation" },
        },
        d = {
            name = "Diagnostics...",
            o = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Open" },
            p = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous" },
            n = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next" },
        },
        f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
        h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code action" },
    },
    d = {
        name = 'Docker...',
    },
}, { prefix = "<leader>" })
