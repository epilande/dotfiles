return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "objc",
        "swift",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sourcekit = {
          filetypes = { "swift", "objective-c", "objective-cpp" },
          -- Native vim.lsp.config signature: (bufnr, on_dir callback)
          root_dir = function(bufnr, on_dir)
            local filepath = vim.api.nvim_buf_get_name(bufnr)
            local found = vim.fs.find(function(name)
              return name == "buildServer.json"
                or name == "Package.swift"
                or name == ".git"
                or name:match("%.xcodeproj$")
                or name:match("%.xcworkspace$")
            end, { path = filepath, upward = true })[1]
            if found then
              on_dir(vim.fs.dirname(found))
            end
          end,
        },
      },
    },
  },
}
