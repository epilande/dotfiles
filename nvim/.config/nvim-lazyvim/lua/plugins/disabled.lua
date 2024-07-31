return {
  { "akinsho/bufferline.nvim", enabled = false },
  -- {
  --   "rcarriga/nvim-notify",
  --   enabled = false,
  -- },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  -- { "mfussenegger/nvim-lint", enabled = false },
  {
    "gbprod/yanky.nvim",
    keys = {
      { "gp", false, mode = { "n", "x" } },
      -- Disable mapping for visual mode. Prefer pasting in visual mode to go to black hole register
      { "p", false, mode = { "x" } },
    },
  },
}
