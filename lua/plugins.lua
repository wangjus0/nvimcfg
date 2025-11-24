-- Lazy loader
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fs.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

	-- LSP
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},

	-- Auto complete
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },

		version = "1.*",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "enter",
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = { documentation = { auto_show = false } },

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},

	-- Easy word surrounds
	{
		"echasnovski/mini.surround",
		version = "*", -- recommended to avoid breaking changes
		config = function()
			require("mini.surround").setup()
		end,
	},

	-- Buffer oil tree
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		dependencies = { { "nvim-mini/mini.icons", opts = {} } },
		lazy = false,

		config = function(_, opts)
			require("oil").setup(opts)

			-- Auto-open Oil if nvim was started on a directory
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					local path = vim.fn.expand("%:p")

					if vim.fn.isdirectory(path) == 1 then
						require("oil").open(path)
					end
				end,
			})
		end,
	},

	-- Auto brackets
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},

	-- Save files to a buffer storage to jump to
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("telescope").setup()
		end,
	},

	-- Flash.nvim (To jump to a work ('s' first couple letters))
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			-- basic jump like hop/easymotion using "s"
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash jump",
			},
		},
	},

	-- Comment plugin (gco, gcc)
	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
		},
	},

	-- Theme
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local c = require("vscode.colors").get_colors()

			require("vscode").setup({
				transparent = false,
				italic_comments = false,
				disable_nvim_tree_bg = true,
				color_overrides = {
					vscBack = "#000000",
				},
			})

			require("vscode").load()
		end,
	},

	-- Prettier
	{
		"stevearc/conform.nvim",
		lazy = false,
		config = function()
			require("conform").setup({
				format_on_save = {
					timeout_ms = 300,
					lsp_fallback = true,
				},
				formatters_by_ft = {
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
					json = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					markdown = { "prettier" },
					yaml = { "prettier" },
				},
			})
		end,
	},

	-- Live Server
	{
		"barrett-ruth/live-server.nvim",
		build = "pnpm add -g live-server",
		cmd = { "LiveServerStart", "LiveServerStop" },
		config = true,
	},

	{
		"akinsho/git-conflict.nvim",
		version = "*",
		config = true,
	},
})
