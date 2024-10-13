-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Disable autoformat for markdown files",
  pattern = { "markdown" },
  callback = function()
    vim.b.autoformat = false
  end,
})

vim.api.nvim_create_autocmd("BufRead", {
  desc = "Disable diagnostics in node_modules",
  pattern = "*/node_modules/*",
  command = "lua vim.diagnostic.disable(0)",
})

vim.api.nvim_create_autocmd("BufRead", {
  desc = "Disable diagnostic for .env files",
  pattern = "*.env",
  command = "lua vim.diagnostic.disable(0)",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  desc = "Auto reload tmux config",
  pattern = { "tmux/.config/tmux/*.conf" },
  command = "!tmux source ~/.config/tmux/tmux.conf",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  desc = "Auto reload aerospace config",
  pattern = { "aerospace.toml" },
  command = "!aerospace reload-config",
})
