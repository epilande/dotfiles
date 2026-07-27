return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            -- disable auto-inserting parens/args on completion (perf)
            complete_function_calls = false,
            typescript = {
              tsserver = {
                -- give tsserver more headroom on large projects
                maxTsServerMemory = 8192,
              },
              preferences = {
                -- stop scanning package.json for auto-import candidates (perf)
                includePackageJsonAutoImports = "off",
              },
              suggest = {
                completeFunctionCalls = false,
              },
            },
            -- LazyVim's typescript extra copies typescript settings to javascript
            -- in its opts function, but merge order with this table is not
            -- guaranteed, so set the javascript variants explicitly too.
            javascript = {
              preferences = {
                includePackageJsonAutoImports = "off",
              },
              suggest = {
                completeFunctionCalls = false,
              },
            },
          },
        },
        eslint = {
          settings = {
            workingDirectory = { mode = "location" },
            run = "onSave",
          },
          -- Native vim.lsp.config signature: (bufnr, on_dir callback)
          root_dir = function(bufnr, on_dir)
            local startpath = vim.api.nvim_buf_get_name(bufnr)
            local found = vim.fs.find(".git", { path = startpath, upward = true })[1]
            if found then
              on_dir(vim.fs.dirname(found))
            end
          end,
        },
      },
      setup = {
        eslint = function()
          local formatter = LazyVim.lsp.formatter({
            name = "eslint: lsp",
            primary = false,
            priority = 200,
            filter = "eslint",
          })
          LazyVim.format.register(formatter)
        end,
      },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-jest",
    },
    opts = function(_, opts)
      table.insert(
        opts.adapters,
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "jest.config.js",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        })
      )
    end,
  },
}
