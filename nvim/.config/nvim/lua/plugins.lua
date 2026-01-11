local map = vim.keymap.set

vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },

	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/tpope/vim-fugitive" },

	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },

	-- Dependency listed explicitly because I don't know any better
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/LinArcX/telescope-env.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },

	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip" },
})

require("catppuccin").setup({
	flavour = "mocha",
})
vim.cmd.colorscheme("catppuccin")

require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff" },
		lualine_c = { "filename" },
		lualine_x = { "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
})

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
map("n", "//", require("oil").open, { desc = "Open oil" })

require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "-" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
	current_line_blame = false,
	preview_config = { border = "rounded" },
})

local gs = require("gitsigns")

map("n", "]c", function()
	if vim.wo.diff then
		return "]c"
	end
	vim.schedule(function()
		gs.next_hunk()
	end)
	return "<Ignore>"
end, { expr = true, desc = "Next hunk" })

map("n", "[c", function()
	if vim.wo.diff then
		return "[c"
	end
	vim.schedule(function()
		gs.prev_hunk()
	end)
	return "<Ignore>"
end, { expr = true, desc = "Previous hunk" })

map("n", "<leader>hs", gs.stage_hunk, { desc = "[H]unk [S]tage" })
map("n", "<leader>hr", gs.reset_hunk, { desc = "[H]unk [R]eset" })
map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "[H]unk [U]ndo stage" })
map("n", "<leader>hp", gs.preview_hunk, { desc = "[H]unk [P]review" })
map("n", "<leader>hb", function()
	gs.blame_line({ full = true })
end, { desc = "[H]unk [B]lame" })
map("n", "<leader>hd", gs.diffthis, { desc = "[H]unk [D]iff" })

-- No need to require Fugitive
map("n", "<leader>gs", ":Git<CR>", { desc = "[G]it [S]tatus" })
map("n", "<leader>gl", ":Git log --oneline -10 %<CR>", { desc = "[G]it [L]og (current file)" })
-- Friendly reminder: :Gvdfiffsplit!<CR> is your friendd
map("n", "<leader>gc", ":Git checkout<Space>", { desc = "[G]it [C]heckout branch" })
map("n", "<leader>gp", ":Git push<CR>", { desc = "[G]it [P]ush" })
map("n", "<leader>gu", ":Git pull<CR>", { desc = "[G]it p[U]ll" })

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"clangd",
		"lua_ls",
		"pyright",
		"bashls",
		"marksman",
		"jsonls",
		"yamlls",
		"verible",
	},
	automatic_installation = true,
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end,
	},
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
		"vimdoc",
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
	},
})

local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
telescope.setup({
	defaults = {
		preview = { treesitter = false },
	},
})
map("n", "<leader>sh", telescope_builtin.help_tags, { desc = "[S]earch [H]elp" })
-- map("n", "<leader>sk", telescope_builtin.keymaps, { desc = "[S]earch [K]eymaps" })
-- map("n", "<leader>ss", telescope_builtin.builtin, { desc = "[S]earch [S]elect telescope builtin" })
map("n", "<leader>sf", telescope_builtin.find_files, { desc = "[S]earch [F]iles" })
map("n", "<leader>sw", telescope_builtin.grep_string, { desc = "[S]earch current [W]ord" })
map("n", "<leader>sg", telescope_builtin.live_grep, { desc = "[S]earch by [G]rep" })
map("n", "<leader>sd", telescope_builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
map("n", "<leader>sr", telescope_builtin.resume, { desc = "[S]earch [R]esume" })
map("n", "<leader>s.", telescope_builtin.oldfiles, { desc = "[S]earch [.] recently opened files" })
map("n", "<leader><leader>", telescope_builtin.buffers, { desc = "[  ] Find existing buffers" })
map("n", "<leader>se", telescope.extensions.env.env, { desc = "[S]earch [E]nvironment variables" })
-- Fuzzyly find in current buffer
map("n", "<leader>/", function()
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
		verilog = { "verible" },
		systemverilog = { "verible" },
	},
})
map("n", "<leader>F", function()
	require("conform").format({ async = false })
end, { desc = "[F]ormat current buffer" })
