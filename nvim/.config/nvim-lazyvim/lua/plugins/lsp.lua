return {
  { import = "plugins.langs" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "dockerfile" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    opts = {
      ---@type vim.diagnostic.Opts
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
          },
        },
      },
      inlay_hints = {
        enabled = false,
      },
    },
  },
  {
    "rmagatti/goto-preview",
    config = function()
      local preview_window_count = 0
      require("goto-preview").setup({
        height = 25,
        post_open_hook = function(buf, win)
          preview_window_count = preview_window_count + 1

          local function close_window()
            if vim.api.nvim_win_is_valid(win) then
              vim.api.nvim_win_close(win, true)
            end

            preview_window_count = preview_window_count - 1

            -- If no more preview windows are open, unregister the mapping
            if preview_window_count == 0 then
              vim.keymap.del("n", "q", { buffer = buf })
            end
          end

          vim.keymap.set("n", "q", close_window, { buffer = buf })
        end,
      })
    end,
    keys = {
      {
        "gp",
        "<cmd>lua require('goto-preview').goto_preview_definition()<cr>",
        desc = "Goto Preview Definition",
      },
    },
  },
}
