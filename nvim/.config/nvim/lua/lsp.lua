local on_attach = function(client, bufnr)
	local map = function(m, l, r)
		vim.keymap.set(m, l, r, { buffer = bufnr })
	end
	map("n", "gd", vim.lsp.buf.definition)
	map("n", "K", vim.lsp.buf.hover)
	map("n", "<leader>rn", vim.lsp.buf.rename)
	map("n", "gD", vim.lsp.buf.declaration)
	map("n", "<leader>ca", vim.lsp.buf.code_action)
	map("n", "[d", vim.diagnostic.goto_prev)
	map("n", "]d", vim.diagnostic.goto_next)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_nvim_lsp = require("cmp_nvim_lsp")
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

vim.fn.sign_define("DiagnosticSignError", { text = "E", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "W", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "I", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "H", texthl = "DiagnosticSignHint" })

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

do
	local cmp = require("cmp")
	local luasnip = require("luasnip")

	local cmp_select = { behavior = cmp.SelectBehavior.Select }

	cmp.setup({
		completion = { autocomplete = false },
		preselect = cmp.PreselectMode.None,
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = {
			["<C-Space>"] = cmp.mapping.complete(), -- manual trigger
			["<CR>"] = cmp.mapping.confirm({ select = true }), -- confirm selection
			["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(cmp_select), { "i", "c" }),
			["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(cmp_select), { "i", "c" }),
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip", priority = 20 },
		}, {
			{ name = "buffer" },
			{ name = "path" },
		}),
	})
end
