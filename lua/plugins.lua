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
    opts = {
      view_options = {
        show_hidden = true,
      },
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

  -- Color Theme
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("github-theme").setup({
        options = {
          transparent = true,
        },
      })

      vim.cmd("colorscheme github_dark")
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true, -- single statusline
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = { "dashboard", "alpha" },
      },

      sections = {
        lualine_a = {
          {
            "mode",
            icon = "",
          },
        },

        lualine_b = {
          {
            "filename",
            path = 1, -- relative path
            symbols = {
              modified = " ●",
              readonly = " ",
              unnamed = "[No Name]",
            },
          },
        },

        lualine_c = {},

        lualine_x = {
          {
            "diagnostics",
            symbols = {
              error = " ",
              warn  = " ",
              info  = " ",
              hint  = "󰌵 ",
            },
          },
          "encoding",
          "filetype",
        },

        lualine_y = {
          {
            "branch",
            icon = "",
          },
        },

        lualine_z = {
          {
            "location",
            icon = "󰍒",
          },
        },
      },
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    },
  },

  {
    "karb94/neoscroll.nvim",
    opts = {
      easing = "quadratic",
    },
  }

})
