return {
  "ibhagwan/fzf-lua",
  keys = {
    -- { "<C-f>", "<cmd>FzfLua files<cr>" },
    { "<C-f>", '<cmd>FzfLua files formatter={"path.filename_first",2}<cr>' },
  },
  opts = {
    fzf_opts = {
      ["--no-scrollbar"] = false,
    },
    -- previewers = {
    --   bat = {
    --     cmd = "bat",
    --     theme = "Catppuccin Mocha",
    --   },
    -- },
    defaults = {
      -- previewer = "bat",
      formatter = "path.filename_first",
    },
    files = {
      fzf_opts = {
        ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-files-history",
      },
    },
    grep = {
      fzf_opts = {
        ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history",
      },
      rg_glob = true,
      -- first returned string is the new search query
      -- second returned string are (optional) additional rg flags
      -- @return string, string?
      rg_glob_fn = function(query)
        local regex, flags = query:match("^(.-)%s%-%-(.*)$")
        -- If no separator is detected will return the original query
        return (regex or query), flags
      end,
    },
    keymap = {
      fzf = {
        ["ctrl-n"] = "down",
        ["ctrl-p"] = "up",
        ["ctrl-d"] = "preview-page-down",
        ["ctrl-u"] = "preview-page-up",
        ["up"] = "prev-history",
        ["down"] = "next-history",
      },
      builtin = {
        ["<C-d>"] = "preview-page-down",
        ["<C-u>"] = "preview-page-up",
      },
    },
  },
}
