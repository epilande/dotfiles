local ls = require("luasnip")

local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node

local function get_node_text(node)
  if node then
    return vim.treesitter.get_node_text(node, 0)
  end
end

-- Get the nearest function name using Treesitter
local function get_nearest_function_name()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()

  local handlers = {
    function_declaration = function(inner_node)
      local identifier = inner_node:child(1)
      return get_node_text(identifier)
    end,
    method_definition = function(inner_node)
      local identifier = inner_node:child(1)
      return get_node_text(identifier)
    end,
    variable_declarator = function(inner_node)
      local init = inner_node:child(1)
      if init and (init:type() == "function_expression" or init:type() == "arrow_function") then
        return get_node_text(inner_node:child(0))
      end
    end,
    arrow_function = function(inner_node)
      local parent = inner_node:parent()
      if parent and parent:type() == "variable_declarator" then
        return get_node_text(parent:child(0))
      end
    end,
  }

  while node do
    local node_type = node:type()
    local handler = handlers[node_type]
    if handler then
      local result = handler(node)
      if result then
        return result
      end
    end
    node = node:parent()
  end

  return "anonymous"
end

-- Get the current filename
local function get_file_name()
  local file = vim.api.nvim_buf_get_name(0)
  return file:match("^.+/(.+)$")
end

-- Get the current line number
local function get_line_number()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  return tostring(line)
end

ls.add_snippets("typescript", {
  s(
    "cll",
    fmta(
      [[
      console.log('🚀 <filename>:<line_number> → <func_name> → <var_label>: ', <var>)<finish>
      ]],
      {
        var = i(1, "var"),
        var_label = rep(1),
        func_name = f(function()
          return get_nearest_function_name()
        end, {}),
        filename = f(function()
          return get_file_name()
        end, {}),
        line_number = f(function()
          return get_line_number()
        end, {}),
        finish = i(0),
      }
    )
  ),
  s(
    "cl",
    fmta(
      [[
      console.log('🚀 <filename>:<line_number> → <func_name>: <string>')<finish>
      ]],
      {
        string = i(1),
        func_name = f(function()
          return get_nearest_function_name()
        end, {}),
        filename = f(function()
          return get_file_name()
        end, {}),
        line_number = f(function()
          return get_line_number()
        end, {}),
        finish = i(0),
      }
    )
  ),
})
