-- https://github.com/nvim-telescope/telescope.nvim/issues/1923#issuecomment-1122642431
local function getVisualSelection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

function SpectreSelection(args)
  args = args or {}
  local input = getVisualSelection()
  args.search_text = input
  require("spectre").open(args)
end

return {
  "nvim-pack/nvim-spectre",
  build = false,
  cmd = "Spectre",
  opts = { open_cmd = "noswapfile vnew" },
  config = function()
    require("spectre").setup({
      mapping = {
        ["toggle_no_ignore"] = {
          map = "tn",
          cmd = '<cmd>lua require("spectre").change_options("no-ignore")<CR>',
          desc = "toggle no ignore",
        },
        ["toggle_no_tests"] = {
          map = "tt",
          cmd = '<cmd>lua require("spectre").change_options("no-tests")<CR>',
          desc = "toggle tests",
        },
      },
      find_engine = {
        ["rg"] = {
          cmd = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--multiline",
            "--column",
          },
          options = {
            ["ignore-case"] = {
              value = "--ignore-case",
              icon = "[I]",
              desc = "ignore case",
            },
            ["hidden"] = {
              value = "--hidden",
              desc = "hidden file",
              icon = "[H]",
            },
            ["no-ignore"] = {
              value = "--no-ignore",
              desc = "no ignore",
              icon = "[N]",
            },
            ["no-tests"] = {
              value = "--glob=!{*.spec.*,*.json,mocks*,*.lock}",
              desc = "no tests",
              icon = "[T]",
            },
          },
        },
      },
      default = {
        find = {
          cmd = "rg",
          options = { "ignore-case", "no-tests" },
        },
      },
    })
  end,
  -- keys = {
  -- {
  --   "<leader>sr",
  --   function()
  --     require("spectre").open({ is_insert_mode = true })
  --   end,
  --   desc = "Replace in files (Spectre)",
  -- },
  -- {
  --   "<leader>sw",
  --   function()
  --     require("spectre").open_visual({ select_word = true })
  --   end,
  --   desc = "Replace Word (Spectre)",
  -- },
  -- {
  --   "<leader>sr",
  --   mode = "v",
  --   function()
  --     SpectreSelection()
  --   end,
  --   desc = "Search & Replace Selection (Spectre)",
  -- },
  -- },
}
