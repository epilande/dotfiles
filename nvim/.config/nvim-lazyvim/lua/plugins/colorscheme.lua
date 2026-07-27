return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = true,
      -- Installed plugins (blink.cmp, snacks, gitsigns, ...) are styled
      -- automatically via auto_integrations; list only custom overrides.
      auto_integrations = true,
      integrations = {
        grug_far = false,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- Use the flavour-specific name: Neovim 0.12 bundles its own
      -- colors/catppuccin.vim, which shadows the plain "catppuccin" name and
      -- stops lazy.nvim from loading the real plugin (it sees the name as
      -- already provided). "catppuccin-mocha" only exists in the plugin.
      colorscheme = "catppuccin-mocha",
    },
  },
}
