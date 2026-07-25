-- PERF: cache the LSP/formatter/linter status string per buffer so the
-- lualine component does no work on statusline redraw. Entries are recomputed
-- only when the attached clients or filetype change (see autocmds below).
local lsp_status_cache = {}

local function compute_lsp_status(bufnr)
  local buf_clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #buf_clients == 0 then
    return "LSP Inactive"
  end

  local filetype = vim.bo[bufnr].filetype
  local formatters = require("conform").list_formatters(bufnr)
  local linters = require("lint").linters_by_ft[filetype] or {}

  local buf_client_names = {}
  local buf_formatters = {}
  local buf_linters = {}

  -- add client
  for _, client in pairs(buf_clients) do
    if client.name ~= "null-ls" and client.name ~= "copilot" then
      table.insert(buf_client_names, client.name)
    end
  end

  -- add formatter
  for _, formatter in pairs(formatters) do
    table.insert(buf_formatters, formatter.name)
  end

  -- add linter
  for _, linter in pairs(linters) do
    table.insert(buf_linters, linter)
  end

  vim.list_extend(buf_client_names, buf_formatters)
  vim.list_extend(buf_client_names, buf_linters)

  local unique_client_names = table.concat(buf_client_names, ", ")
  local language_servers = string.format("[%s]", unique_client_names)

  return language_servers
end

-- Recompute the cached status only when clients or the filetype change...
vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach", "BufEnter", "FileType" }, {
  group = vim.api.nvim_create_augroup("lualine_lsp_status", { clear = true }),
  callback = function(args)
    lsp_status_cache[args.buf] = compute_lsp_status(args.buf)
  end,
})

-- ...and drop the entry on buffer delete to avoid leaking cache keys.
vim.api.nvim_create_autocmd("BufDelete", {
  group = "lualine_lsp_status",
  callback = function(args)
    lsp_status_cache[args.buf] = nil
  end,
})

local lsp = {
  function()
    local bufnr = vim.api.nvim_get_current_buf()
    local status = lsp_status_cache[bufnr]
    if status == nil then
      status = compute_lsp_status(bufnr)
      lsp_status_cache[bufnr] = status
    end
    return status
  end,
  color = { gui = "bold" },
}

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    local icons = require("lazyvim.config").icons

    vim.o.laststatus = vim.g.lualine_laststatus

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },

        lualine_c = {
          LazyVim.lualine.root_dir(),
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { LazyVim.lualine.pretty_path() },
        },
        lualine_x = {
          lsp,
        },
        lualine_y = {
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = { fg = Snacks.util.color("Statement") },
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = { fg = Snacks.util.color("Constant") },
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = { fg = Snacks.util.color("Debug") },
          },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = { fg = Snacks.util.color("Special") },
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_z = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        -- lualine_z = {
        --   function()
        --     return " " .. os.date("%R")
        --   end,
        -- },
      },
      extensions = { "neo-tree", "lazy" },
    }
  end,
}
