local globExcludeList = "*.spec.*,*_test.*,*.proto,*.pb.go,*.json,*.yaml,mocks,patches,.git"

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("grug-far-custom-keybinds", { clear = true }),
  pattern = { "grug-far" },
  callback = function()
    vim.keymap.set("n", "<localleader>w", function()
      local state = unpack(require("grug-far").toggle_flags({ "--fixed-strings" }))
      vim.notify("grug-far: toggled --fixed-strings " .. (state and "ON" or "OFF"))
    end, { desc = "Toggle --fixed-strings", buffer = true })

    vim.keymap.set("n", "<localleader>i", function()
      local state = unpack(require("grug-far").toggle_flags({ "--ignore-case" }))
      vim.notify("grug-far: toggled --ignore-case " .. (state and "ON" or "OFF"))
    end, { desc = "Toggle --ignore-case", buffer = true })

    vim.keymap.set("n", "<localleader>h", function()
      local state = unpack(require("grug-far").toggle_flags({ "--hidden" }))
      vim.notify("grug-far: toggled --hidden " .. (state and "ON" or "OFF"))
    end, { desc = "Toggle --hidden", buffer = true })

    vim.keymap.set("n", "<localleader>m", function()
      local state = unpack(require("grug-far").toggle_flags({ "--multiline --multiline-dotall" }))
      vim.notify("grug-far: toggled --multiline --multiline-dotall " .. (state and "ON" or "OFF"))
    end, { desc = "Toggle --multiline", buffer = true })

    vim.keymap.set("n", "<localleader>g", function()
      require("grug-far").toggle_flags({ "--glob=!{" .. globExcludeList .. "}" })
    end, { desc = "Toggle test files", buffer = true })
  end,
})

return {
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          grug.grug_far({
            transient = true,
            prefills = {
              flags = "--ignore-case --glob=!{" .. globExcludeList .. "}",
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
}
