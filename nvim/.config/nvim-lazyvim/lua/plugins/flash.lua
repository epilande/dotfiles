return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    search = {
      -- multi_window = false,
    },
    modes = {
      search = {
        enabled = false,
      },
    },
  },
  keys = {
    {
      "<leader>k",
      function()
        -- Update search register with current word
        vim.fn.setreg("/", vim.fn.expand("<cword>"))
        -- vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
        -- Enable search highlight
        vim.cmd("set hlsearch")

        require("flash").jump({
          pattern = vim.fn.expand("<cword>"),
        })
      end,
      desc = "Search Word",
    },
  },
}
