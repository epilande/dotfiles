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
          root_dir = function(filepath)
            local util = require("lspconfig.util")
            return util.root_pattern("buildServer.json")(filepath)
              or util.root_pattern("*.xcodeproj", "*.xcworkspace")(filepath)
              or util.root_pattern("Package.swift")(filepath)
              or vim.fs.dirname(vim.fs.find(".git", { path = filepath, upward = true })[1])
          end,
        },
      },
    },
  },
}
