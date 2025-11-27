vim.pack.add({
    { src = "https://github.com/catppuccin/nvim"},
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/williamboman/mason.nvim" },
    { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter"},
    { src = "https://github.com/folke/which-key.nvim" },

    -- Dependency listed explicitly because I don't know any better
    { src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/LinArcX/telescope-env.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },

    -- Completion plugins
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/saadparwaiz1/cmp_luasnip" },
})

catppuccin = require("catppuccin").setup({
    flavour = "mocha",
})
vim.cmd.colorscheme("catppuccin")

require("oil").setup({
    view_options = {
        show_hidden = true,
    },
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
	},
	columns = {
		"permissions",
		"icon",
	},
	float = {
		max_width = 0.7,
		max_height = 0.6,
		border = "rounded",
	},
})
vim.keymap.set("n", "//", require("oil").open, { desc = "Open oil" })

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { 
        "clangd",
        "lua_ls",
        "pyright",
        "bashls",
        "marksman",
        "jsonls",
        "yamlls"
    },
    automatic_installation = true,
})

require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "c",
        "cpp",
        "lua",
        "python",
        "bash",
        "json",
        "yaml",
        "markdown",
        "markdown_inline",
        "vimdoc"
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
        },
    }
})

local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
telescope.setup({
	defaults = {
		preview = { treesitter = false },
	}
})
vim.keymap.set("n", "<leader>sh", telescope_builtin.help_tags, { desc = "[S]earch [H]elp" })
-- vim.keymap.set("n", "<leader>sk", telescope_builtin.keymaps, { desc = "[S]earch [K]eymaps" })
-- vim.keymap.set("n", "<leader>ss", telescope_builtin.builtin, { desc = "[S]earch [S]elect telescope builtin" })
vim.keymap.set("n", "<leader>sf", telescope_builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sw", telescope_builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", telescope_builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", telescope_builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", telescope_builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", telescope_builtin.oldfiles, { desc = "[S]earch [.] recently opened files" })
vim.keymap.set("n", "<leader><leader>", telescope_builtin.buffers, { desc = "[  ] Find existing buffers" })
vim.keymap.set("n", "<leader>se", telescope.extensions.env.env, { desc = "[S]earch [E]nvironment variables" })
-- Fuzzyly find in current buffer
vim.keymap.set("n", "<leader>/", function()
    telescope_builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
    }))
end, { desc = "[/] Fuzzily search in current buffer" })

require("which-key").setup({
    icons = {
        mappings = false,
        keys = {
            Up = "<Up>",
            Down = "<Down>",
            Left = "<Left>",
            Right = "<Right>",
            C = "<C-...>",
            M = "<M-...>",
            S = "<S-...>",
            D = "<D-...>",
            CR = "<CR>",
            Esc = "<Esc>",
            ScrollWheelUp = "<ScrollWheelUp>",
            ScrollWheelDown = "<ScrollWheelDown>",
            NL = "<NL>",
            BS = "<BS>",
            Space = "<Space>",
            Tab = "<Tab>",
            breadcrumb = ">",
            separator = "->",
            group = "+",
        },
    },
})

require("conform").setup({
    format_on_save = true,
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        cpp = { "clang-format" },
        c = { "clang-format" },
        sh = { "shfmt" },
        json = { "jq" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
    },
})
vim.keymap.set("n", "<leader>F", function() require("conform").format({ async = false }) end, { desc = "[F]ormat current buffer" })