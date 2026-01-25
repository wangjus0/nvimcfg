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

	-- Mason LSP
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
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

	-- Buffer oil tree
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

	-- Save files to a buffer storage to jump to
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Fuzzy finder (fzf lua)
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local fzf = require("fzf-lua")
			fzf.setup({ { "fzf-vim", "max-perf", "hide" } })
		end,
	},

	-- Color Theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			integrations = {
				cmp = true,
				gitsigns = true,
				treesitter = true,
				notify = false,
				alpha = true,
				mini = {
					enabled = true,
					indentscope_color = "",
				},
				telescope = true,
			},
		},
		init = function()
			vim.cmd.colorscheme("catppuccin-mocha")

			-- you can configure highlights by doing something like:
			vim.cmd.hi("comment gui=none")
		end,
	},

	-- Prettier (formatter)
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
					"111",
					"112",
					"113",
					"114",
					"115",
					"121",
					"122",
					"123",
					"124",
					"125",
					"131",
					"132",
					"133",
					"134",
					"135",
					"141",
					"142",
					"143",
					"144",
					"145",
					"151",
					"152",
					"153",
					"154",
					"155",
					"211",
					"212",
					"213",
					"214",
					"215",
					"221",
					"222",
					"223",
					"224",
					"225",
					"231",
					"232",
					"233",
					"234",
					"235",
					"241",
					"242",
					"243",
					"244",
					"245",
					"251",
					"252",
					"253",
					"254",
					"255",
				},
				up_key = "k",
				down_key = "j",
				hidden_file_types = { "undotree" },
				hidden_buffer_types = { "terminal", "nofile" },
			})
		end,
	},

	-- Animated Cursor
	{
		"sphamba/smear-cursor.nvim",
		opts = {
			-- Have the smear animation between buffers
			smear_between_buffers = true,

			-- Faster smear animations
			stiffness = 0.8,
			trailing_stiffness = 0.6,
			stiffness_insert_mode = 0.7,
			trailing_stiffness_insert_mode = 0.7,
			damping = 0.95,
			damping_insert_mode = 0.95,
			distance_stop_animating = 0.5,
		},
	},

	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			-- Eviline config for lualine
			-- Author: shadmansaleh
			-- Credit: glepnir
			local lualine = require("lualine")
			local colors = {
				bg = "#1e2030",
				fg = "#cdd6f4",
				yellow = "#f9e2af",
				cyan = "#89dceb",
				darkblue = "#89b4fa",
				green = "#a6e3a1",
				orange = "#fab387",
				violet = "#cba6f7",
				magenta = "#f5c2e7",
				blue = "#89b4fa",
				red = "#f38ba8",
			}

			local conditions = {
				buffer_not_empty = function()
					return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
				end,
				hide_in_width = function()
					return vim.fn.winwidth(0) > 80
				end,
				check_git_workspace = function()
					local filepath = vim.fn.expand("%:p:h")
					local gitdir = vim.fn.finddir(".git", filepath .. ";")
					return gitdir and #gitdir > 0 and #gitdir < #filepath
				end,
			}

			-- Config
			local config = {
				options = {
					-- Disable sections and component separators
					component_separators = "",
					section_separators = "",
					theme = {
						-- We are going to use lualine_c an lualine_x as left and
						-- right section. Both are highlighted by c theme .  So we
						-- are just setting default looks o statusline
						normal = { c = { fg = colors.fg, bg = colors.bg } },
						inactive = { c = { fg = colors.fg, bg = colors.bg } },
					},
				},
				sections = {
					-- these are to remove the defaults
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					-- These will be filled later
					lualine_c = {},
					lualine_x = {},
				},
				inactive_sections = {
					-- these are to remove the defaults
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					lualine_c = {},
					lualine_x = {},
				},
			}

			-- Inserts a component in lualine_c at left section
			local function ins_left(component)
				table.insert(config.sections.lualine_c, component)
			end

			-- Inserts a component in lualine_x at right section
			local function ins_right(component)
				table.insert(config.sections.lualine_x, component)
			end

			ins_left({
				function()
					return "▊"
				end,
				color = { fg = colors.blue }, -- Sets highlighting of component
				padding = { left = 0, right = 1 }, -- We don't need space before this
			})

			ins_left({
				-- mode component
				function()
					return ""
				end,
				color = function()
					-- auto change color according to neovims mode
					local mode_color = {
						n = colors.red,
						i = colors.green,
						v = colors.blue,
						[""] = colors.blue,
						V = colors.blue,
						c = colors.magenta,
						no = colors.red,
						s = colors.orange,
						S = colors.orange,
						[""] = colors.orange,
						ic = colors.yellow,
						R = colors.violet,
						Rv = colors.violet,
						cv = colors.red,
						ce = colors.red,
						r = colors.cyan,
						rm = colors.cyan,
						["r?"] = colors.cyan,
						["!"] = colors.red,
						t = colors.red,
					}
					return { fg = mode_color[vim.fn.mode()] }
				end,
				padding = { right = 1 },
			})

			ins_left({
				-- filesize component
				"filesize",
				cond = conditions.buffer_not_empty,
			})

			ins_left({
				"filename",
				cond = conditions.buffer_not_empty,
				color = { fg = colors.magenta, gui = "bold" },
			})

			ins_left({ "location" })

			ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

			ins_left({
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " " },
				diagnostics_color = {
					error = { fg = colors.red },
					warn = { fg = colors.yellow },
					info = { fg = colors.cyan },
				},
			})

			-- Insert mid section. You can make any number of sections in neovim :)
			-- for lualine it's any number greater then 2
			ins_left({
				function()
					return "%="
				end,
			})

			-- Add components to right sections
			ins_right({
				"o:encoding", -- option component same as &encoding in viml
				fmt = string.upper, -- I'm not sure why it's upper case either ;)
				cond = conditions.hide_in_width,
				color = { fg = colors.green, gui = "bold" },
			})

			ins_right({
				"fileformat",
				fmt = string.upper,
				icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
				color = { fg = colors.green, gui = "bold" },
			})

			ins_right({
				"branch",
				icon = "",
				color = { fg = colors.violet, gui = "bold" },
			})

			ins_right({
				"diff",
				-- Is it me or the symbol for modified us really weird
				symbols = { added = " ", modified = "󰝤 ", removed = " " },
				diff_color = {
					added = { fg = colors.green },
					modified = { fg = colors.orange },
					removed = { fg = colors.red },
				},
				cond = conditions.hide_in_width,
			})

			ins_right({
				function()
					return "▊"
				end,
				color = { fg = colors.blue },
				padding = { left = 1 },
			})

			-- Now don't forget to initialize lualine
			lualine.setup(config)
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
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

	-- Typescript tooling (import updates, references, etc)
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
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
})
