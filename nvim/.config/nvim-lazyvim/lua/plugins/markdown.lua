return {
  {
    "iamcco/markdown-preview.nvim",
    lazy = true,
    event = "VeryLazy",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
    keys = {
      {
        "<leader>cp",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
        ft = "markdown",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    opts = {
      latex = { enabled = false },
      render_modes = { "n", "c", "i", "v" },
      checkbox = {
        position = "inline",
        unchecked = {
          icon = "󰄱",
        },
        checked = {
          icon = "󰄲",
          highlight = "RenderMarkdownChecked",
        },
        custom = {
          ["in-progress"] = { raw = "[/]", rendered = "󰿦", highlight = "RenderMarkdownWarn" },
          urgent = { raw = "[!]", rendered = "󰄱", highlight = "RenderMarkdownError" },
          canceled = { raw = "[~]", rendered = "󰂭", highlight = "RenderMarkdownError" },
          todo = { raw = "[-]", rendered = "", highlight = "Comment" },
          forwarded = { raw = "[>]", rendered = "󰒊", highlight = "RenderMarkdownHint" },
          scheduled = { raw = "[<]", rendered = "󰃰", highlight = "RenderMarkdownHint" },
          info = { raw = "[i]", rendered = "󰋼", highlight = "RenderMarkdownInfo" },
          question = { raw = "[?]", rendered = "", highlight = "RenderMarkdownWarn" },
          idea = { raw = "[I]", rendered = "󰛨", highlight = "RenderMarkdownWarn" },
          pros = { raw = "[p]", rendered = "󰔓", highlight = "RenderMarkdownSuccess" },
          cons = { raw = "[c]", rendered = "󰔑", highlight = "RenderMarkdownError" },
          star = { raw = "[s]", rendered = "󰓎", highlight = "RenderMarkdownWarn" },
          f = { raw = "[f]", rendered = "󰈸", highlight = "RenderMarkdownH2" },
        },
      },
      heading = {
        -- position = "inline",
        icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
        signs = {},
        backgrounds = { "DiffDelete", "DiffChange" },
      },
    },
  },
  {
    "epilande/checkbox-cycle.nvim",
    ft = "markdown",
    opts = {
      states = {
        { "[ ]", "[/]", "[x]", "[-]", "[~]" },
        { "[!]", "[x]" },
        { "[>]", "[<]" },
        { "[i]", "[?]", "[I]", "[p]", "[c]", "[s]", "[f]" },
      },
    },
    keys = {
      {
        "<CR>",
        "<Cmd>CheckboxCycleNext<CR>",
        desc = "Checkbox Next",
        ft = { "markdown" },
        mode = { "n", "v" },
      },
      {
        "<S-CR>",
        "<Cmd>CheckboxCyclePrev<CR>",
        desc = "Checkbox Previous",
        ft = { "markdown" },
        mode = { "n", "v" },
      },
    },
  },
}
