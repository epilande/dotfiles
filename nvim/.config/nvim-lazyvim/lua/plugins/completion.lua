return {
  {
    "saghen/blink.cmp",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = {
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
      completion = {
        menu = {
          draw = {
            treesitter = { "lsp" },
            gap = 2,
          },
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          border = "rounded",
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
          },
        },
        ghost_text = { enabled = false },
      },

      signature = { window = { border = "single" } },

      sources = {
        default = { "lsp", "path", "luasnip", "buffer" },
      },

      fuzzy = {
        -- Disabling this matches the behavior of fzf
        use_typo_resistance = false,
      },

      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-s>"] = {
          function(cmp)
            cmp.show({ providers = { "luasnip" } })
          end,
        },
      },
    },
  },
}
