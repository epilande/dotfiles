return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {},
  enabled = true,
  init = function()
    -- PERF: barbecue drives breadcrumbs through nvim-navic, which re-requests
    -- documentSymbols on every cursor move. For large files that churn is
    -- expensive, so flag big buffers with navic's documented per-buffer var,
    -- which limits context updates to the CursorHold event instead.
    -- See :help vim.b.navic_lazy_update_context
    local max_filesize = 500 * 1024 -- ~500KB
    vim.api.nvim_create_autocmd("BufReadPre", {
      group = vim.api.nvim_create_augroup("barbecue_large_file", { clear = true }),
      callback = function(args)
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
        if ok and stats and stats.size > max_filesize then
          vim.b[args.buf].navic_lazy_update_context = true
        end
      end,
    })
  end,
}
