return {
	{
		'williamboman/mason.nvim',
		lazy = false,
		opts = {},
	},

	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		config = function()
			local cmp = require('cmp')

			cmp.setup({
				sources = {
					{name = 'nvim_lsp'},
				},
				mapping = cmp.mapping.preset.insert({
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),
				}),
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
			})
		end
	},

	-- LSP
	{
		'neovim/nvim-lspconfig',
		cmd = {'LspInfo', 'LspInstall', 'LspStart'},
		event = {'BufReadPre', 'BufNewFile'},
		dependencies = {
			{'hrsh7th/cmp-nvim-lsp'},
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},
		},
		init = function()
			-- Reserve a space in the gutter
			-- This will avoid an annoying layout shift in the screen
			vim.opt.signcolumn = 'yes'
		end,
		config = function()
			local lsp_defaults = require('lspconfig').util.default_config

			-- Add cmp_nvim_lsp capabilities settings to lspconfig
			-- This should be executed before you configure any language server
			lsp_defaults.capabilities = vim.tbl_deep_extend(
			'force',
			lsp_defaults.capabilities,
			require('cmp_nvim_lsp').default_capabilities()
			)

			--
			-- LspAttach is where you enable features that only work
			-- if there is a language server active in the file
			vim.api.nvim_create_autocmd('LspAttach', {
				desc = 'LSP actions',
				callback = function(event)
					vim.keymap.set('n', '<leader>K', '<cmd>lua vim.lsp.buf.hover()<cr>', {buffer = event.buf, desc="Hover"})
					vim.keymap.set('n', '<leader>g', '<cmd>WhichKey <leader>g<cr>', {buffer = event.buf, desc="Go To"})

					vim.keymap.set('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<cr>', {buffer = event.buf, desc="Go to Definition"})
					vim.keymap.set('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', {buffer = event.buf, desc="Go to Declaration"})
					vim.keymap.set('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', {buffer = event.buf, desc="Go to Implementation"})
					vim.keymap.set('n', '<leader>go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', {buffer = event.buf, desc="Go to Type Definition"})
					vim.keymap.set('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<cr>', {buffer = event.buf, desc="Go to References"})
					vim.keymap.set('n', '<leader>gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', {buffer = event.buf, desc="Signature Help"})
					vim.keymap.set('n', '<leader><F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', {buffer = event.buf, desc="Rename"})
					vim.keymap.set('n', '<leader><F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', {buffer = event.buf, desc="Format"})
					vim.keymap.set('n', '<leader><F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', {buffer = event.buf, desc="Code Action"})
					vim.keymap.set('n', '<leader><F5>', '<cmd>lua vim.diagnostic.open_float()<cr>', {buffer = event.buf, desc="Line Diagnostics"})
				end,
			})

			require('mason-lspconfig').setup({
				ensure_installed = {},
				handlers = {
					-- this first function is the "default handler"
					-- it applies to every language server without a "custom handler"
					function(server_name)
						require('lspconfig')[server_name].setup({})
					end,
					["lua_ls"] = function ()
						local lspconfig = require("lspconfig")
						lspconfig.lua_ls.setup {
							settings = {
								Lua = {
									diagnostics = {
										globals = { "vim" }
									}
								}
							}
						}
					end,
					["tsserver"] = function ()
						local lspconfig = require("lspconfig")
						lspconfig.tsserver.setup {
							settings = {
								typescript = {
									diagnostics = {
										globals = { "vim" }
									}
								}
							}
						}
					end,
					["tailwindcss"] = function ()
						local lspconfig = require("lspconfig")
						lspconfig.tailwindcss.setup {}
					end,
					["rust_analyzer"] = function ()
						local lspconfig = require("lspconfig")
						lspconfig.rust_analyzer.setup {
							settings = {
								['rust-analyzer'] = {
									diagnostics = {
										enable = false;
									}
								}
							}
						}
					end,

				}
			})
		end
	}
}
