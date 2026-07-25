return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  { import = "lazyvim.plugins.extras.formatting.prettier" },
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
          root_dir = function(startpath)
            return vim.fs.dirname(vim.fs.find(".git", { path = startpath, upward = true })[1])
          end,
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
