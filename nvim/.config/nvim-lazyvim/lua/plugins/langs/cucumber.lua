return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cucumber_language_server = {
          settings = {
            cucumber = {
              features = { "playwright/features/**/*.feature" },
              glue = { "playwright/src/steps/**/*.ts" },
            },
          },
        },
      },
    },
  },
}
