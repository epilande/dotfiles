local function generate_keys_markdown_table()
  -- Get all key mappings
  local modes = { "n", "i", "v", "x", "c", "t" }
  local keymaps = {}

  for _, mode in ipairs(modes) do
    local mappings = vim.api.nvim_get_keymap(mode)
    for _, mapping in ipairs(mappings) do
      if mapping.lhs and mapping.rhs and mapping.lhs ~= "" and mapping.rhs ~= "" then
        local lhs = mapping.lhs:gsub(" ", "<Leader>"):gsub("|", "\\|"):gsub("`", "\\`")
        local rhs = mapping.rhs:gsub("|", "\\|"):gsub("`", "\\`")
        table.insert(keymaps, { mode = mode, lhs = lhs, rhs = rhs })
      end
    end
  end

  -- Generate Markdown table
  local lines = {}
  table.insert(lines, "| Mode | Keys | Command |")
  table.insert(lines, "|------|------|---------|")

  for _, map in ipairs(keymaps) do
    table.insert(lines, string.format("| %s | `%s` | `%s` |", map.mode, map.lhs, map.rhs))
  end

  -- Write to a markdown file
  local script_path = debug.getinfo(1).source:match("@?(.*/)")
  local file = io.open(script_path .. "key-mappings.md", "w")
  for _, line in ipairs(lines) do
    file:write(line .. "\n")
  end
  file:close()

  print("Key mappings have been written to key_mappings.md")
end

generate_keys_markdown_table()
