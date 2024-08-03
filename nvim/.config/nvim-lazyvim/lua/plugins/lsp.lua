return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "dockerfile", "graphql" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    -- other settings removed for brevity
    opts = {
      ---@type lspconfig.options
      inlay_hints = {
        enabled = false,
      },
      servers = {
        eslint = {
          settings = {
            workingDirectory = { mode = "location" },
          },
          root_dir = require("lspconfig").util.find_git_ancestor,
        },
        cucumber_language_server = {
          settings = {
            cucumber = {
              features = { "playwright/features/**/*.feature" },
              glue = { "playwright/src/steps/**/*.ts" },
            },
          },
        },
        bashls = {
          filetypes = { "sh", "zsh" },
        },
      },
      setup = {
        eslint = function()
          local function get_client(buf)
            return LazyVim.lsp.get_clients({ name = "eslint", bufnr = buf })[1]
          end

          local formatter = LazyVim.lsp.formatter({
            name = "eslint: lsp",
            primary = false,
            priority = 200,
            filter = "eslint",
          })

          -- Use EslintFixAll on Neovim < 0.10.0
          if not pcall(require, "vim.lsp._dynamic") then
            formatter.name = "eslint: EslintFixAll"
            formatter.sources = function(buf)
              local client = get_client(buf)
              return client and { "eslint" } or {}
            end
            formatter.format = function(buf)
              local client = get_client(buf)
              if client then
                local diag = vim.diagnostic.get(buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
                if #diag > 0 then
                  vim.cmd("EslintFixAll")
                end
              end
            end
          end

          -- register the formatter with LazyVim
          LazyVim.format.register(formatter)
        end,
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
      -- {
      --   "gpt",
      --   "<cmd>lua require('goto-preview').goto_preview_type_definition()<cr>",
      --   desc = "Goto Preview Type Definition",
      -- },
      -- {
      --   "gpi",
      --   "<cmd>lua require('goto-preview').goto_preview_implementation()<cr>",
      --   desc = "Goto Preview Implementation",
      -- },
      -- {
      --   "gpD",
      --   "<cmd>lua require('goto-preview').goto_preview_declaration()<cr>",
      --   desc = "Goto Preview Declaration",
      -- },
      -- {
      --   "gpr",
      --   "<cmd>lua require('goto-preview').goto_preview_references()<cr>",
      --   desc = "Goto Preview References",
      -- },
    },
  },
}
