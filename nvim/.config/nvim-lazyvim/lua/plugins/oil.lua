return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      columns = {
        "icon",
      },
      delete_to_trash = true,
      view_options = {
        show_hidden = true,
      },
      float = {
        padding = 2,
        max_width = 150,
        max_height = 0,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
      keymaps = {
        ["q"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["<C-d>"] = "actions.preview_scroll_down",
        ["<C-u>"] = "actions.preview_scroll_up",
        ["<C-h>"] = false,
        ["<C-l>"] = false,
      },
    })
  end,
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open Parent Directory ../" },
    { "<leader>e", "<cmd>lua require('oil').toggle_float()<cr>", desc = "Oil " },
  },
}
