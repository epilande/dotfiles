-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Resize window using <A+hjkl>
map("n", "<A-h>", ":vertical resize -2<cr>", { desc = "Decrease window width", silent = true })
map("n", "<A-j>", ":resize -2<cr>", { desc = "Decrease window height", silent = true })
map("n", "<A-k>", ":resize +2<cr>", { desc = "Increase window height", silent = true })
map("n", "<A-l>", ":vertical resize +2<cr>", { desc = "Increase window width", silent = true })

-- map("n", "<leader>k", "*Nzz", { desc = "Search Word", noremap = true })

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })

map("v", "p", '"_dP')
map("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })

map("n", "<leader>ck", function()
  -- Get current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  -- Get current word under cursor
  local word = vim.fn.expand("<cword>")
  -- Set register to the console.log snippet
  vim.fn.setreg("+", "console.log('🚀 " .. word .. ":', " .. word .. ");")
  -- Paste the snippet
  vim.cmd("put +")
  -- Reindent the pasted snippet
  vim.cmd("normal! `[=`]")
  -- Move cursor back to original position
  vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_pos[2] })
end, { desc = "console.log 🚀" })

map("i", "jk", "<Esc>")

-- Remap alt backspace to ctrl-w to delete word
map("i", "<A-BS>", "<C-w>")

-- vim-tmux-navigator
if os.getenv("TMUX") then
  map({ "n", "v" }, "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
  map({ "n", "v" }, "<C-j>", "<cmd>TmuxNavigateDown<cr>")
  map({ "n", "v" }, "<C-k>", "<cmd>TmuxNavigateUp<cr>")
  map({ "n", "v" }, "<C-l>", "<cmd>TmuxNavigateRight<cr>")
end

map("n", "<leader>gl", "<cmd>Gitsigns blame_line<cr>", { desc = "Blame" })

map("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "New Note" })
map("n", "<leader>od", "<cmd>ObsidianToday<cr>", { desc = "Daily Note" })
map("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>", { desc = "Yesterday's Note" })

-- DEBUG: reload snippets
map("n", "<leader>S", function()
  -- require("luasnip").cleanup()
  require("luasnip.loaders.from_lua").load({
    paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
  })
end, { desc = "Reload Snippets" })

-- Copy file path
map("n", "<leader>fy", function()
  local filename = vim.fn.expand("%")
  vim.fn.system("pbcopy", filename)
  print("Copied to clipboard: " .. filename)
end, { desc = "Copy file path" })
