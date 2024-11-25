local checkbox_states = {
  "- [ ] ",
  "- [/] ",
  "- [x] ",
  "- [!] ",
  "- [~] ",
  "- [-] ",
  "- [>] ",
  "- [<] ",
  "",
}

local function get_next_state(current_state)
  for i, state in ipairs(checkbox_states) do
    if state == current_state then
      return checkbox_states[(i % #checkbox_states) + 1]
    end
  end
  return checkbox_states[1]
end

local function find_current_state(line)
  for _, state in ipairs(checkbox_states) do
    local start_idx, end_idx = string.find(line, vim.pesc(state))
    if start_idx then
      return start_idx, end_idx, state
    end
  end
  return nil, nil, ""
end

local function cycle_checkbox_state()
  local current_line = vim.api.nvim_get_current_line()
  local start_idx, end_idx, current_state = find_current_state(current_line)

  if not start_idx then
    -- Default to empty state if no checklist item is found
    start_idx, end_idx, current_state = 0, 0, ""
  end

  local new_state = get_next_state(current_state)
  local indent = string.match(current_line, "^%s*") or ""
  -- Strip leading spaces after the checkbox
  local line_after_checkbox = string.sub(current_line, end_idx + 1):match("^%s*(.*)$")
  local new_line
  if new_state == "" then
    new_line = indent .. line_after_checkbox
  else
    new_line = indent .. new_state .. line_after_checkbox
  end

  vim.api.nvim_set_current_line(new_line)
end

return {
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
      -- Toggle check-boxes.
      -- ["<cr>"] = {
      --   action = function()
      --     local util = require("obsidian.util")
      --     if util.cursor_on_markdown_link(nil, nil, true) then
      --       vim.cmd("ObsidianFollowLink")
      --     else
      --       return cycle_checkbox_state()
      --     end
      --   end,
      --   opts = { buffer = true },
      -- },
    },
    ui = {
      enable = false,
      --   checkboxes = {
      --     [" "] = { char = "󰄱", hl_group = "Comment" }, -- Todo
      --     ["/"] = { char = "󰿦", hl_group = "DiagnosticWarn" }, -- In-progress
      --     ["x"] = { char = "󰄲", hl_group = "DiagnosticOk" }, -- Done
      --     ["!"] = { char = "󰄱", hl_group = "DiagnosticError" }, -- Urgent
      --     ["~"] = { char = "󰂭", hl_group = "ObsidianTilde" }, -- Canceled
      --     ["-"] = { char = "", hl_group = "Comment" }, -- Skip
      --     [">"] = { char = "󰒊", hl_group = "DiagnosticHint" }, -- Forwarded
      --     ["<"] = { char = "󰃰", hl_group = "DiagnosticHint" }, -- Scheduled
      --
      --     ["i"] = { char = "󰋼", hl_group = "DiagnosticInfo" }, -- Info
      --     ["?"] = { char = "", hl_group = "DiagnosticWarn" }, -- Question
      --     ["I"] = { char = "󰛨", hl_group = "DiagnosticWarn" }, -- Idea
      --     ["p"] = { char = "󰔓", hl_group = "DiagnosticOk" }, -- Pros
      --     ["c"] = { char = "󰔑", hl_group = "DiagnosticError" }, -- Cons
      --     ["s"] = { char = "󰓎", hl_group = "DiagnosticWarn" }, -- Star
      --     ["f"] = { char = "󰈸", hl_group = "ObsidianRightArrow" }, -- Fire
      --   },
      --   external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
    },
  },
}
