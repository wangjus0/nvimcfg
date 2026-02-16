------------ Plugin Manager ------------

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

	-- Mason
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	-- Mason LSP
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"clangd",
					"html",
					"lua_ls",
					"gopls",
					"ts_ls",
					"pyright",
					"tailwindcss",
				},
			})
		end,
	},

	-- LSP Config
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.lsp.config.lua_ls = {
				capabilities = capabilities,
			}

			vim.lsp.config.gopls = {
				capabilities = capabilities,
			}

			vim.lsp.config.tsserver = {
				capabilities = capabilities,
			}

			vim.lsp.config.pyright = {
				capabilities = capabilities,
			}

			vim.lsp.config.clangd = {
				capabilities = capabilities,
			}

			vim.lsp.config.html = {
				capabilities = capabilities,
			}

			vim.lsp.enable({
				"lua_ls",
				"gopls",
				"tsserver",
				"pyright",
				"clangd",
				"html",
			})
		end,
	},

	-- Oil
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			view_options = {
				show_hidden = true,
			},
			lsp_file_methods = {
				enabled = true,
				timeout_ms = 1000,
			},
			skip_confirm_for_simple_edits = true,
		},
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

			vim.api.nvim_create_autocmd("User", {
				pattern = "OilActionsPost",
				callback = function(event)
					local actions = event.data and event.data.actions
					local action = actions and actions[1]
					if not action or action.type ~= "move" then
						return
					end

					local ok, snacks = pcall(require, "snacks")
					if not ok or not snacks.rename then
						return
					end

					snacks.rename.on_rename_file(action.src_url, action.dest_url, function()
						vim.cmd("silent! wall")
					end)
				end,
			})
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			"LinArcX/telescope-env.nvim",
		},
		opts = function(_, opts)
			local themes = require("telescope.themes")

			opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {

				file_ignore_patterns = {
					"%.git/",
					"node_modules/",
					"%.lock",
					"%.cache/",
				},

				prompt_prefix = "   ",
				selection_caret = "  ",
				entry_prefix = "  ",

				sorting_strategy = "ascending",
				layout_strategy = "horizontal",

				layout_config = {
					prompt_position = "top",
					width = 0.9,
					height = 0.85,
					preview_cutoff = 40,
				},

				preview = {
					treesitter = true,
				},

				winblend = 0,
				color_devicons = true,
				path_display = { "smart" },

				border = true,
				borderchars = {
					"─",
					"│",
					"─",
					"│",
					"╭",
					"╮",
					"╯",
					"╰",
				},

				mappings = {
					i = {
						["<C-j>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
						["<C-q>"] = "send_to_qflist",
						["<Esc>"] = "close",
					},
					n = {
						["q"] = "close",
					},
				},
			})

			opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
				find_files = {
					hidden = true,
				},
				buffers = {
					sort_lastused = true,
					previewer = false,
				},
				live_grep = {
					only_sort_text = true,
				},
				diagnostics = {
					theme = "ivy",
				},
			})

			opts.extensions = vim.tbl_deep_extend("force", opts.extensions or {}, {
				["ui-select"] = themes.get_dropdown({
					previewer = false,
					winblend = 0,
					borderchars = {
						"─",
						"│",
						"─",
						"│",
						"╭",
						"╮",
						"╯",
						"╰",
					},
				}),
				env = {},
			})
		end,
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			telescope.load_extension("ui-select")
			telescope.load_extension("env")
		end,
	},

	-- Auto Format
	{
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>w",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "format buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_after_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true, html = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				sql = { "sql_formatter", stop_after_first = true },
				javascript = { "prettierd" },
				typescript = { "prettierd", "biome" },
				typescriptreact = { "prettierd", "biome" },
				javascriptreact = { "prettierd" },
				markdown = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				cpp = { "clang-format" },
				c = { "clang-format" },
				go = { "gofumpt" },
			},
		},
	},

	-- Comfy Numbers (for easy vertical num nav)
	{
		"mluders/comfy-line-numbers.nvim",
		config = function()
			require("comfy-line-numbers").setup({
				labels = {
					"1",
					"2",
					"3",
					"4",
					"5",
					"11",
					"12",
					"13",
					"14",
					"15",
					"21",
					"22",
					"23",
					"24",
					"25",
					"31",
					"32",
					"33",
					"34",
					"35",
					"41",
					"42",
					"43",
					"44",
					"45",
					"51",
					"52",
					"53",
					"54",
					"55",
				},
				up_key = "k",
				down_key = "j",
				hidden_file_types = { "undotree" },
				hidden_buffer_types = { "terminal", "nofile" },
			})
		end,
	},

	-- Comment.nvim (gcc, gco, etc)
	{
		"numToStr/Comment.nvim",
		opts = {
			toggler = {
				block = "gbc",
			},
		},
	},

	-- Tmux navigator (vim navigation for tmux panes)
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},

	-- Mini.nvim (small independent plugins/modules)
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.surround").setup()
			require("mini.pairs").setup()
		end,
	},

	-- Color Scheme
	{
		"vague-theme/vague.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other plugins
		config = function()
			-- NOTE: you do not need to call setup if you don't want to.
			require("vague").setup({
				transparent = false, -- don't set background
				-- disable bold/italic globally in `style`
				bold = true,
				italic = true,
				style = {
					-- "none" is the same thing as default. But "italic" and "bold" are also valid options
					boolean = "bold",
					number = "none",
					float = "none",
					error = "bold",
					comments = "italic",
					conditionals = "none",
					functions = "none",
					headings = "bold",
					operators = "none",
					strings = "italic",
					variables = "none",

					-- keywords
					keywords = "none",
					keyword_return = "italic",
					keywords_loop = "none",
					keywords_label = "none",
					keywords_exception = "none",

					-- builtin
					builtin_constants = "bold",
					builtin_functions = "none",
					builtin_types = "bold",
					builtin_variables = "none",
				},
				-- plugin styles where applicable
				-- make an issue/pr if you'd like to see more styling options!
				plugins = {
					cmp = {
						match = "bold",
						match_fuzzy = "bold",
					},
					dashboard = {
						footer = "italic",
					},
					lsp = {
						diagnostic_error = "bold",
						diagnostic_hint = "none",
						diagnostic_info = "italic",
						diagnostic_ok = "none",
						diagnostic_warn = "bold",
					},
					neotest = {
						focused = "bold",
						adapter_name = "bold",
					},
					telescope = {
						match = "bold",
					},
				},

				-- Override highlights or add new highlights
				on_highlights = function(highlights, colors) end,

				-- Override colors
				colors = {
					bg = "#141415",
					inactiveBg = "#1c1c24",
					fg = "#cdcdcd",
					floatBorder = "#878787",
					line = "#252530",
					comment = "#606079",
					builtin = "#b4d4cf",
					func = "#c48282",
					string = "#e8b589",
					number = "#e0a363",
					property = "#c3c3d5",
					constant = "#aeaed1",
					parameter = "#bb9dbd",
					visual = "#333738",
					error = "#d8647e",
					warning = "#f3be7c",
					hint = "#7e98e8",
					operator = "#90a0b5",
					keyword = "#6e94b2",
					type = "#9bb4bc",
					search = "#405065",
					plus = "#7fa563",
					delta = "#f3be7c",
				},
			})
			vim.cmd("colorscheme vague")
		end,
	},

	{
		"romgrk/barbar.nvim",
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			icons = {
				buffer_index = false,
				buffer_number = false,
				button = false,
				diagnostics = {
					[vim.diagnostic.severity.ERROR] = { enabled = false },
					[vim.diagnostic.severity.WARN] = { enabled = false },
					[vim.diagnostic.severity.INFO] = { enabled = false },
					[vim.diagnostic.severity.HINT] = { enabled = false },
				},
				filetype = {
					enabled = false,
				},
				separator = { left = "", right = "" },
				modified = { button = "" },
				pinned = { button = "" },
			},
		},
		version = "^1.0.0",
	},
})
