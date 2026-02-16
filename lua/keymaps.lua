------------ Nvim Mappings ------------

-- Leader
vim.g.mapleader = " "

-- Save
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })

-- Centers cursor for half page jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Groups and move text up/dowm in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Move through wrapped lines
vim.keymap.set("n", "<Up>", "gk", { desc = "Move up through wrapped lines" })
vim.keymap.set("n", "<Down>", "gj", { desc = "Move down through wrapped lines" })

-- Quick indent
vim.keymap.set("n", "<", "<<", { noremap = true })
vim.keymap.set("n", ">", ">>", { noremap = true })

-- Show Diagnostic
vim.keymap.set("n", "D", vim.diagnostic.open_float, {
	desc = "[S]how [D]iagnostic",
})

-- Split horizontal/vertical
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "[S]plit [v]ertical" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "[S]plit [h]orizontal" })

------------ Plugin Mappings ------------

-- Oil
vim.keymap.set("n", "<leader>e", function()
	require("oil").open(vim.fn.expand("%:p:h"))
end, { desc = "Open Oil (current file dir)" })

-- Telescope
vim.keymap.set("n", "<leader>pf", require("telescope.builtin").find_files, { -- Find files
	desc = "[F]ind [F]iles",
})

vim.keymap.set("n", "<leader>pw", require("telescope.builtin").live_grep, { -- Search for words
	desc = "[F]ind [W]ord",
})

vim.keymap.set("n", "<leader>gd", require("telescope.builtin").lsp_type_definitions, {
	desc = "[G]o [D]efintiion",
})

-- Barbar
vim.keymap.set("n", "th", "<Cmd>BufferGoto 1<CR>", { desc = "Go to tab 1" })
vim.keymap.set("n", "tj", "<Cmd>BufferGoto 2<CR>", { desc = "Go to tab 2" })
vim.keymap.set("n", "tk", "<Cmd>BufferGoto 3<CR>", { desc = "Go to tab 3" })
vim.keymap.set("n", "tl", "<Cmd>BufferGoto 4<CR>", { desc = "Go to tab 4" })
vim.keymap.set("n", "t;", "<Cmd>BufferGoto 5<CR>", { desc = "Go to tab 5" })
