return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip").config.setup({
        keep_roots = true,
        link_roots = true,
        link_children = true,
        update_events = "TextChanged,TextChangedI",
      })
      require("luasnip").filetype_extend("typescriptreact", { "typescript" })
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "/lua/snippets" } })
    end,
  },
}
