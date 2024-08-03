return {
  {
    enabled = false,
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true,
    cmd = "Neogit",
    keys = {
      { "<leader>gn", "<cmd>Neogit kind=vsplit<cr>", desc = "Neogit", silent = true, noremap = true },
    },
  },
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gd", "", desc = "+diffview", mode = { "n", "v" } },
      { "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gdc", "<cmd>tabclose<cr>", desc = "Diffview Close" },
      { "<leader>gdh", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview File History" },
    },
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function(_, opts)
      -- print(opts)
      -- require("git-worktree").setup(opts)
      require("telescope").load_extension("git_worktree")
    end,
    keys = {
      { "<leader>gw", "", desc = "+git-worktree", mode = { "n", "v" } },
      {
        "<leader>gws",
        function()
          require("telescope").extensions.git_worktree.git_worktrees({
            path_display = {},
          })
        end,
        desc = "Manage Worktrees",
      },
      {
        "<leader>gwc",
        function()
          require("telescope").extensions.git_worktree.create_git_worktree()
        end,
        desc = "Create Worktree",
      },
    },
  },
}
