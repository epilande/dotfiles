-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.relativenumber = true
vim.opt.conceallevel = 1
vim.opt.showtabline = 0
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"

vim.opt.clipboard = ""

local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

local osc52_clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste,
  },
}

local local_clipboard = {
  name = "system",
  copy = {
    ["+"] = "pbcopy",
    ["*"] = "pbcopy",
  },
  paste = {
    ["+"] = "pbpaste",
    ["*"] = "pbpaste",
  },
}

local function is_remote_tmux()
  local output = vim.fn.system("tmux show-environment SSH_CONNECTION 2>/dev/null")
  return vim.v.shell_error == 0 and output:match("SSH_CONNECTION") ~= nil
end

if vim.env.SSH_CONNECTION or is_remote_tmux() then
  vim.g.clipboard = osc52_clipboard
else
  vim.g.clipboard = local_clipboard
end
