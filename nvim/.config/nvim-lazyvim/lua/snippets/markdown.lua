local ls = require("luasnip")

local fmt = require("luasnip.extras.fmt").fmt

local s = ls.snippet
local i = ls.insert_node

-- Helper function to create code block snippets
local function create_code_block_snippet(lang)
  return s(
    {
      trig = lang,
      name = "Codeblock",
      desc = lang .. " codeblock",
    },
    fmt(
      [[
```{}
{}
```
      ]],
      {
        lang,
        i(1),
      }
    )
  )
end

-- Define languages for code blocks
local languages = {
  "lua",
  "sql",
  "go",
  "regex",
  "bash",
  "yaml",
  "json",
  "csv",
  "javascript",
  "typescript",
  "tsx",
  "python",
  "dockerfile",
  "html",
  "css",
  "sh",
}

local code_block_snippets = {}

-- Generate snippets for languages
for _, lang in ipairs(languages) do
  table.insert(code_block_snippets, create_code_block_snippet(lang))
end

local snippets = {
  s(
    "det",
    fmt(
      [[
<details>
  <summary>{}</summary>
  {}
</details>
      ]],
      {
        i(1),
        i(0),
      }
    )
  ),
}

vim.list_extend(snippets, code_block_snippets)

ls.add_snippets("markdown", snippets)
