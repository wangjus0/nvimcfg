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
-- vim.keymap.set("n", "<leader>pf", require("telescope.builtin").find_files, { -- Find files
-- 	desc = "[F]ind [F]iles",
-- })
--
-- vim.keymap.set("n", "<leader>pw", require("telescope.builtin").live_grep, { -- Search for words
-- 	desc = "[F]ind [W]ord",
-- })
--
-- vim.keymap.set("n", "<leader>gd", require("telescope.builtin").lsp_type_definitions, {
-- 	desc = "[G]o [D]efintiion",
-- })

-- Harpoon
local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end)

vim.keymap.set("n", "<leader>h", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "th", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "tj", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "tk", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "tl", function()
	harpoon:list():select(4)
end)
vim.keymap.set("n", "t;", function()
	harpoon:list():select(5)
end)

-- Neotree

vim.keymap.set("n", "<leader>lt", function()
	require("neo-tree.command").execute({
		toggle = true,
		position = "float",
	})
end, { desc = "Toggle Neo-tree (float)" })

-- Diffview

vim.keymap.set("n", "<leader>do", ":DiffviewOpen<CR>")
vim.keymap.set("n", "<leader>dc", ":DiffviewClose<CR>")

local fzf = require("fzf-lua")

vim.keymap.set("n", "<leader>pf", fzf.files, { desc = "[F]ind [F]iles" })

vim.keymap.set("n", "<leader>pw", fzf.live_grep_native, { desc = "[F]ind [W]ord" })

vim.keymap.set("n", "<leader>fb", fzf.git_branches, { desc = "[F]ind by Git [B]ranches" })
vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document, { desc = "[F]ind by Git [B]ranches" })
-- vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "[G]oto [D]efinition" })

vim.keymap.set("n", "gd", function()
	require("fzf-lua").lsp_definitions({
		jump1 = true,
	})
end, { desc = "Go to definition" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover Documentation" })
