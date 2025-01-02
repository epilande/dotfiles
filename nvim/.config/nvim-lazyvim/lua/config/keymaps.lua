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

-- Define logging templates for different languages
local log_templates = {
  javascript = "console.log('🚀 %s:', %s);",
  python = "print(f'🚀 %s: {%s}')",
  lua = "dd('🚀 ' .. '%s' .. ':', %s)",
  go = 'fmt.Printf("🚀 %s: %%v\\n", %s)',
  rust = 'println!("🚀 {}: {:?}", "%s", %s);',
  sh = 'echo "🚀 %s: ${%s}"',
}

map("n", "<leader>ck", function()
  -- Get current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  -- Get current word under cursor
  local word = vim.fn.expand("<cword>")
  -- Get current filetype
  local filetype = vim.bo.filetype
  -- Get the appropriate template or fallback to javascript
  local template = log_templates[filetype] or log_templates.javascript
  -- Construct log string based on template
  local log_string = string.format(template, word, word)
  -- Find next empty line
  local current_line = cursor_pos[1]
  local lines = vim.api.nvim_buf_get_lines(0, current_line - 1, -1, false)
  local empty_line_offset = 0
  for i, line in ipairs(lines) do
    if line:match("^%s*$") then
      empty_line_offset = i - 1
      break
    end
  end
  -- If no empty line found, insert at next line
  local target_line = current_line + empty_line_offset - 1
  -- Insert the log at the target line
  vim.api.nvim_buf_set_lines(0, target_line, target_line, false, { log_string })
  -- Reindent the newly inserted line
  vim.cmd(tostring(target_line + 1) .. "normal! ==")
  -- Move cursor back to original position
  vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_pos[2] })
end, { desc = "Insert debug log 🚀" })

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
map("n", "<leader>rs", function()
  -- require("luasnip").cleanup()
  require("luasnip.loaders.from_lua").load({
    paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
  })
end, { desc = "Reload Snippets" })

-- Copy file path
map("n", "<leader>fy", function()
  local filename = vim.fn.expand("%:p")
  local relative_filename = vim.fn.fnamemodify(filename, ":.")
  vim.fn.system("pbcopy", relative_filename)
  print("Copied to clipboard: " .. relative_filename)
end, { desc = "Copy file path" })

-- Search & replace word under the cursor
map("n", "<leader>S", ":%s/<C-r><C-w>//g<Left><Left>", { desc = "Replace word under cursor" })
-- Search & replace selected text
map("v", "<leader>S", "y:%s/\\<<C-r>0\\>//g<Left><Left>", { desc = "Replace selected text" })
