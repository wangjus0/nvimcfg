------------ Nvim Mappings ------------

-- Leader
vim.g.mapleader = " "

-- Save
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })

-- Centers cursor for half page jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Centers cursor when deleting chunks
vim.keymap.set("v", "d", "dzz", { noremap = true })

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
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
	desc = "Show diagnostics at cursor",
})
------------ Plugin Mappings ------------

-- Oil
vim.keymap.set("n", "<leader>e", function()
	require("oil").open(vim.fn.expand("%:p:h"))
end, { desc = "Open Oil (current file dir)" })

-- Harpoon
local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end)
vim.keymap.set("n", "<leader>h", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

for i = 1, 9 do
	vim.keymap.set("n", "<leader>" .. i, function()
		require("harpoon"):list():select(i)
	end, { desc = "Harpoon goto " .. i })
end

-- Fzf Lua
local fzf = require("fzf-lua")

vim.keymap.set("n", "<leader>ff", function()
	fzf.files({
		fd_opts = "--type f --exclude node_modules",
	})
end, { desc = "[F]ind [F]iles" })

vim.keymap.set("n", "<leader>fw", function()
	fzf.live_grep_native({ cmd = "rg --color=always --smart-case -g '!{.git,node_modules}/'" })
end, { desc = "[F]ind [W]ord" })

vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "[G]oto [D]efinition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover Documentation" })

-- TSTools
vim.keymap.set("n", "<leader>rf", "<cmd>TSToolsFileReferences<cr>", { desc = "[R]e-[f]erences" })
vim.keymap.set("n", "<leader>rn", "<cmd>TSToolsRenameFile<cr>", { desc = "[R]e-[n]ame" })
