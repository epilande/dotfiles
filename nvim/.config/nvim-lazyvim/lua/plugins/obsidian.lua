return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    cmd = {
      "ObsidianBacklinks",
      "ObsidianToday",
      "ObsidianLinks",
      "ObsidianNew",
      "ObsidianOpen",
      "ObsidianQuickSwitch",
      "ObsidianSearch",
    },
    event = {
      "BufReadPre " .. vim.fn.resolve(vim.fn.expand("~/Documents/notes")) .. "/*",
      "BufNewFile " .. vim.fn.resolve(vim.fn.expand("~/Documents/notes")) .. "/*",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-cmp",
      "telescope.nvim",
    },
    config = function(_, opts)
      -- Setup obsidian.nvim
      require("obsidian").setup(opts)

      -- https://github.com/epwalsh/obsidian.nvim/issues/770#issuecomment-2557300925
      -- HACK: fix error, disable completion.nvim_cmp option, manually register sources
      local cmp = require("cmp")
      cmp.register_source("obsidian", require("cmp_obsidian").new())
      cmp.register_source("obsidian_new", require("cmp_obsidian_new").new())
      cmp.register_source("obsidian_tags", require("cmp_obsidian_tags").new())

      -- Create which-key mappings for common commands.
      local wk = require("which-key")

      wk.add({
        { "<leader>o", group = "Obsidian" },
        { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
        { "<leader>oc", "<cmd>lua require('obsidian').util.toggle_checkbox()<cr>", desc = "Toggle Checkbox" },
        { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Daily Note" },
        { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Links" },
        { "<leader>om", "<cmd>ObsidianTemplate<cr>", desc = "Template" },
        { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Note" },
        { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open Note" },
        { "<leader>op", "<cmd>ObsidianPasteImg<cr>", desc = "Paste Image" },
        { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch" },
        { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search" },
        { "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "Tags" },
        { "<leader>ow", "<cmd>ObsidianWorkspace<cr>", desc = "Workspace" },
        { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Yesterday's Note" },
      })

      wk.add({
        mode = { "v" },
        { "<leader>o", group = "Obsidian" },
        {
          "<leader>oe",
          function()
            local title = vim.fn.input({ prompt = "Enter title (optional): " })
            vim.cmd("ObsidianExtractNote " .. title)
          end,
          desc = "Extract text into new note",
        },
        {
          "<leader>ol",
          function()
            vim.cmd("ObsidianLink")
          end,
          desc = "Link text to an existing note",
        },
        {
          "<leader>on",
          function()
            vim.cmd("ObsidianLinkNew")
          end,
          desc = "Link text to a new note",
        },
      })
    end,
    opts = {
      completion = {
        nvim_cmp = false,
      },
      workspaces = {
        {
          name = "Dev",
          path = "~/Documents/notes/dev",
        },
      },
      daily_notes = {
        folder = "Daily",
      },
      open_app_foreground = false,
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = tostring(os.time()) .. "-" .. string.char(math.random(65, 90))
          end
        end
        return suffix
      end,
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({ "open", url })
      end,
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
      },
      ui = {
        enable = false,
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = { "saghen/blink.compat" },
    opts = {
      sources = {
        default = { "obsidian", "obsidian_new", "obsidian_tags" },
        providers = {
          obsidian = {
            name = "obsidian",
            module = "blink.compat.source",
          },
          obsidian_new = {
            name = "obsidian_new",
            module = "blink.compat.source",
          },
          obsidian_tags = {
            name = "obsidian_tags",
            module = "blink.compat.source",
          },
        },
      },
    },
  },
}
