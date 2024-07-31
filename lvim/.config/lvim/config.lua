-- general
lvim.log.level = "warn"
lvim.format_on_save = false
-- lvim.format_on_save = false
-- lvim.colorscheme = "tokyonight"
-- lvim.colorscheme = "tokyonight-night"
lvim.colorscheme = "tokyodark"
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
-- lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
	name = "+Trouble",
	r = { "<cmd>Trouble lsp_references<cr>", "References" },
	f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
	d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
	q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
	l = { "<cmd>Trouble loclist<cr>", "LocationList" },
	w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
}

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
-- lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- lvim.builtin.terminal.open_mapping = nil

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
	"bash",
	"css",
	"go",
	"graphql",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"proto",
	"python",
	"typescript",
	"tsx",
	"rust",
	"sql",
	"yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings

-- -- make sure server will always be installed even if the server is in skipped_servers list
lvim.lsp.installer.setup.ensure_installed = {
	"eslint",
	-- "marksman",
	-- "markdown_oxide",
	--     "sumeko_lua",
	--     "jsonls",
}

-- require("lvim.lsp.manager").setup("marksman")
-- require("lvim.lsp.manager").setup("markdown_oxide")

-- -- change UI setting of `LspInstallInfo`
-- -- see <https://github.com/williamboman/nvim-lsp-installer#default-configuration>
-- lvim.lsp.installer.setup.ui.check_outdated_servers_on_open = false
-- lvim.lsp.installer.setup.ui.border = "rounded"
-- lvim.lsp.installer.setup.ui.keymaps = {
--     uninstall_server = "d",
--     toggle_server_expand = "o",
-- }

-- ---@usage disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- local util = require("lspconfig/util")
-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", {})

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

lvim.lsp.null_ls.setup.fallback_severity = vim.diagnostic.severity.WARN

-- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ command = "black", filetypes = { "python" } },
	{ command = "isort", filetypes = { "python" } },
	{
		-- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
		command = "prettierd",
		---@usage arguments to pass to the formatter
		-- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
		-- extra_args = { "--print-with", "100" },
		---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
		filetypes = { "typescript", "typescriptreact", "json", "jsonc", "graphql", "css" },
	},
	{ command = "goimports", filetypes = { "go" } },
	{ command = "stylua", filetypes = { "lua" } },
	{ command = "sql-formatter", filetypes = { "sql" } },
	-- {
	-- 	command = "eslint_d",
	-- 	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	-- },
})

-- set additional linters
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{ command = "flake8", filetypes = { "python" } },
	{
		-- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
		command = "shellcheck",
		---@usage arguments to pass to the formatter
		-- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
		extra_args = { "--severity", "warning" },
	},
	-- {
	-- 	command = "cspell",
	-- 	filetypes = { "python", "javascript", "typescript", "typescriptreact" },
	-- },
	-- {
	-- 	command = "eslint",
	-- 	filetypes = { "typescript", "typescriptreact" },
	-- },
	{
		command = "eslint_d",
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	},
	-- {
	-- 	command = "sqlfluff",
	-- 	filetypes = { "sql" },
	-- 	extra_args = { "--dialect", "mysql" },
	-- },
})

local code_actions = require("lvim.lsp.null-ls.code_actions")
code_actions.setup({
	{
		command = "eslint_d",
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	},
})

-- CUSTOM SETTINGS

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

vim.opt.relativenumber = true
vim.opt.clipboard = ""

vim.opt.conceallevel = 1

lvim.builtin.breadcrumbs.active = false
lvim.builtin.bufferline.active = false
vim.opt.showtabline = 0
-- vim.opt.colorcolumn = "80"

-- ~/.vim/temp_dirs/undodir
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.undofile = true -- enable persistent undo

-- lvim.builtin.telescope.defaults.file_ignore_patterns = { ".git" }
lvim.builtin.telescope.defaults.layout_config = {
	horizontal = {
		width = 0.9,
		preview_width = function(_, cols, _)
			local width = math.floor(cols * 0.45)
			local maxCol = 120
			if width > maxCol then
				return maxCol
			else
				return width
			end
		end,
	},
}

local _, actions = pcall(require, "telescope.actions")

-- lvim.builtin.telescope.defaults.path_display = { shorten = nil }
-- lvim.builtin.telescope.defaults.path_display = { "smart" }
lvim.builtin.telescope.defaults.path_display = { "truncate" }
lvim.builtin.telescope.defaults.mappings = {
	n = {
		["<c-c>"] = actions.close,
	},
	i = {
		["<c-h>"] = "which_key",
		["<a-bs>"] = { "<c-s-w>", type = "command" },
	},
}
lvim.builtin.telescope.pickers = {
	buffers = {
		mappings = {
			i = {
				["<c-x>"] = actions.delete_buffer,
			},
		},
	},
}

lvim.builtin.project.manual_mode = true
-- lvim.builtin.project.patterns = { ".git", "package.json" }
-- lvim.builtin.alpha.active = false
lvim.builtin.nvimtree.setup.update_cwd = false
lvim.builtin.nvimtree.setup.update_focused_file.update_cwd = false

lvim.keys.normal_mode["<C-f>"] =
	"<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files,--glob,!**/.git/* theme=ivy<cr>"

lvim.keys.normal_mode["<C-b>"] = "<cmd>Telescope buffers theme=dropdown previewer=false sort_lastused=true<cr>"

-- Jump to last buffer
keymap("n", "<C-Space>", "<C-^>", opts)

-- Treat long lines as break lines (useful when moving around in them).
vim.api.nvim_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })

vim.api.nvim_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Quickly select text you just pasted
keymap("n", "gV", "`[v`]")

-- Don't yank on visual paste
keymap("v", "p", '"_dP', opts)

keymap("i", "jk", "<Esc>", opts)

lvim.builtin.which_key.mappings["qq"] = {
	"<cmd>lua require('lvim.utils.functions').smart_quit()<CR>",
	"Quit",
}

lvim.builtin.which_key.mappings["f"] = {
	function()
		require("lvim.lsp.utils").format({ timeout_ms = 2000 })
	end,
	"Format File",
}

lvim.builtin.which_key.mappings["sa"] = {
	"<cmd>Telescope find_files theme=ivy previewer=false find_command=rg,--hidden,--no-ignore,--files<cr>",
	"Find All Files",
}

lvim.builtin.which_key.mappings["sg"] = {
	"<cmd>Telescope live_grep<cr>",
	"Live Grep",
}

-- lvim.builtin.which_key.mappings["st"] = {
lvim.builtin.which_key.mappings.s.t = {
	"<cmd>Telescope resume<cr>",
	"Telescope Resume",
}

lvim.builtin.which_key.mappings.s.o = {
	"<cmd>Telescope buffers sort_lastused=true<cr>",
	"Find Buffer",
}

-- lvim.builtin.which_key.mappings.s.r = {
-- 	"<cmd>lua require('spectre').open({ is_insert_mode=true })<cr>",
-- 	"Spectre",
-- }

lvim.builtin.which_key.mappings["r"] = {
	name = "Replace",
	r = { "<cmd>lua require('spectre').open({ is_insert_mode=true })<cr>", "Replace" },
	w = { "<cmd>lua require('spectre').open_visual({ select_word=true })<cr>", "Replace Word" },
	f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Replace Buffer" },
}

-- lvim.builtin.which_key.mappings["ss"] = {
-- 	"<cmd>SymbolsOutline<cr>",
-- 	"Symbols",
-- }

lvim.builtin.which_key.mappings["gy"] = {
	"<cmd>lua require('gitlinker').get_buf_range_url('n')<cr>",
	"Git Link",
}

lvim.builtin.which_key.mappings.b.c = {
	"<cmd>BufferKill<CR>",
	"Close Buffer",
}

lvim.builtin.which_key.mappings.O = {
	"<CMD>Oil<CR>",
	"Open directory in Oil",
}

lvim.builtin.which_key.mappings.e = {
	"<cmd>lua require('oil').toggle_float()<CR>",
	"Explorer",
}

lvim.builtin.which_key.mappings["u"] = { "<cmd>UndotreeToggle<cr>", "Undo Tree" }

-- Search current word without moving cursor
lvim.builtin.which_key.mappings["k"] = { "*Nzz", "Search Word" }

lvim.builtin.which_key.mappings["y"] = {
	y = {
		'"+yy',
		"Yank line to clipboard",
	},
}
lvim.builtin.which_key.vmappings["y"] = {
	'"+y',
	"Yank to clipboard",
}
lvim.builtin.which_key.vmappings["p"] = {
	'"+p',
	"Paste from clipboard",
}

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

function GrepSelectionInBuffer()
	local input = getVisualSelection()
	require("telescope.builtin").current_buffer_fuzzy_find({ default_text = input })
end

function GrepSelection()
	local input = getVisualSelection()
	require("telescope.builtin").live_grep({ default_text = input })
end

function SpectreSelection(args)
	args = args or {}
	local input = getVisualSelection()
	args.search_text = input
	require("spectre").open(args)
end

lvim.builtin.which_key.vmappings["s"] = {
	name = "Search",
	s = {
		"<cmd>lua GrepSelectionInBuffer()<cr>",
		"Search Selection in Buffer",
	},
	g = {
		"<cmd>lua GrepSelection()<cr>",
		"Search Selection",
	},
}

lvim.builtin.which_key.vmappings["r"] = {
	name = "Replace",
	r = {
		"<cmd>lua SpectreSelection()<cr>",
		"Search & Replace Selection",
	},
	f = {
		"<cmd>lua SpectreSelection({ path = vim.fn.expand('%') })<cr>",
		"Search & Replace Selection In Buffer",
	},
}

-- lvim.builtin.which_key.vmappings.r = {
-- 	"<cmd>lua SpectreSelection()<cr>",
-- 	"Replace",
-- }

-- nnoremap <leader>sw <cmd>lua require('spectre').open_visual({select_word=true})<CR>
-- vnoremap <leader>s <esc>:lua require('spectre').open_visual()<CR>
-- -- lvim.builtin.which_key.mappings["S"] = {
-- -- }

-- lvim.keys.normal_mode["K"] = ""
-- keymap("n", "K", "*Nzz", opts)
-- lvim.keys.normal_mode["gh"] = "<cmd>lua vim.lsp.buf.hover()<cr>"

-- keymap("n", "gh", "*Nzz", opts)

-- -- Beginning of text line
-- keymap("n", "H", "g^", opts)
-- -- End of text line
-- keymap("n", "L", "g$", opts)

-- Map Alt-[h,j,k,l] for resizing a window split
keymap("n", "<A-h>", ":vertical resize -2<cr>", opts)
keymap("n", "<A-j>", ":resize -2<cr>", opts)
keymap("n", "<A-k>", ":resize +2<cr>", opts)
keymap("n", "<A-l>", ":vertical resize +2<cr>", opts)

-- Remap alt backspace to ctrl backspace
keymap("i", "<A-BS>", "<C-w>", opts)

-- Key mapping for LSP Saga
-- keymap({ "n", "v" }, "<leader>la", "")
keymap("n", "gh", "<cmd>Lspsaga finder<CR>")
keymap("n", "gR", "<cmd>Lspsaga rename<CR>")
keymap("n", "gp", "<cmd>Lspsaga peek_definition<CR>")

lvim.builtin.which_key.mappings.l.a = { "<cmd>Lspsaga code_action<CR>", "Lspsaga Code Action" }
lvim.builtin.which_key.mappings.l.o = { "<cmd>Lspsaga outline<CR>", "Lspsaga Outline" }
lvim.builtin.which_key.mappings.l.c = { "<cmd>Lspsaga show_cursor_diagnostics<CR>", "Cursor Diagnostics" }
lvim.builtin.which_key.mappings.t.p = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Lspsaga Prev Diagnostic" }
lvim.builtin.which_key.mappings.t.n = { "<cmd>Lspsaga diagnostic_jump_next<CR>", "Lspsaga Next Diagnostic" }
-- lvim.builtin.which_key.mappings["la"] = { "<cmd>Lspsaga code_action<CR>", "Lspsaga Code Action" }
-- lvim.builtin.which_key.mappings["lo"] = { "<cmd>Lspsaga outline<CR>", "Lspsaga Outline" }
-- lvim.builtin.which_key.mappings["lc"] = { "<cmd>Lspsaga show_cursor_diagnostics<CR>", "Cursor Diagnostics" }
-- lvim.builtin.which_key.mappings["tp"] = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Lspsaga Prev Diagnostic" }
-- lvim.builtin.which_key.mappings["tn"] = { "<cmd>Lspsaga diagnostic_jump_next<CR>", "Lspsaga Next Diagnostic" }

lvim.builtin.which_key.mappings["m"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Harpoon Menu" }
lvim.builtin.which_key.mappings["a"] = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Harpoon Add" }
lvim.builtin.which_key.mappings["1"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "Goto 1" }
lvim.builtin.which_key.mappings["2"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "Goto 2" }
lvim.builtin.which_key.mappings["3"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "Goto 3" }
lvim.builtin.which_key.mappings["4"] = { "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", "Goto 4" }
-- lvim.builtin.which_key.setup.ignore_missing = true
-- keymap("n", "H", "<cmd>lua require('harpoon.ui').nav_prev()<CR>", opts)
-- keymap("n", "L", "<cmd>lua require('harpoon.ui').nav_next()<CR>", opts)

-- local wk = require("which-key")
-- local function deregister(prefix, lhs, mode)
-- 	pcall(wk.register, { [lhs] = "which_key_ignore" }, { prefix = prefix })
-- 	pcall(vim.api.nvim_del_keymap, mode or "n", prefix .. lhs)
-- end

-- deregister("leader", "m")
-- deregister("leader", "a")
-- deregister("leader", "1")
-- deregister("leader", "2")
-- deregister("leader", "3")
-- deregister("leader", "4")

lvim.builtin.which_key.mappings["G"] = {
	"<cmd>lua require('performance_toggle').toggle_performance_mode()<CR>",
	"Toggle performance mode",
}

keymap("t", "<Esc>", "<C-\\><C-n>", opts)

lvim.builtin.which_key.mappings["c"] = {
	name = "+ChatGPT",
	c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
	-- e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction", mode = { "n", "v" } },
	g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
	-- t = { "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
	-- k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
	-- d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
	a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
	-- o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
	s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
	f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
	x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
	-- r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
	-- l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },
}

-- lvim.builtin.which_key.mappings.d.l = {
-- 	function()
-- 		require("debugprint").debugprint({ variable = true })
-- 	end,
-- 	"Debug Print Variable",
-- }

local components = require("lvim.core.lualine.components")

lvim.builtin.lualine.sections = {
	lualine_a = {
		components.mode,
	},
	lualine_b = {
		components.branch,
		{
			"filename",
			-- path = 1,
			path = 0,
		},
	},
	lualine_c = {
		components.diff,
		components.python_env,
	},
}

-- Additional Plugins
lvim.plugins = {
	{ "christoomey/vim-tmux-navigator" },
	{ "tpope/vim-surround" },

	{
		"tiagovla/tokyodark.nvim",
		opts = {
			-- custom options here
		},
		config = function(_, opts)
			require("tokyodark").setup(opts) -- calling setup is optional
			vim.cmd([[colorscheme tokyodark]])
		end,
	},

	{ "catppuccin/nvim", name = "catppuccin", priority = 1000, opts = {
		flavour = "mocha",
	} },

	-- { "folke/tokyonight.nvim" },
	-- { "lunarvim/colorschemes" },
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
	-- {
	-- 	"lukas-reineke/indent-blankline.nvim",
	-- 	event = "BufRead",
	-- 	setup = function()
	-- 		vim.g.indentLine_enabled = 1
	-- 		vim.g.indent_blankline_char = "▏"
	-- 		vim.g.indent_blankline_filetype_exclude = { "help", "terminal", "dashboard" }
	-- 		vim.g.indent_blankline_buftype_exclude = { "terminal" }
	-- 	end,
	-- },
	{ "kevinhwang91/nvim-bqf", ft = "qf" },
	{ "mbbill/undotree" },
	{
		"windwp/nvim-spectre",
		event = "BufRead",
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
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({ "css", "scss", "html", "javascript" }, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
			})
		end,
	},
	{
		"ruifm/gitlinker.nvim",
		event = "BufRead",
		dependencies = "nvim-lua/plenary.nvim",
	},
	-- {
	-- 	"simrat39/symbols-outline.nvim",
	-- 	config = function()
	-- 		require("symbols-outline").setup()
	-- 	end,
	-- },
	{
		"glepnir/lspsaga.nvim",
		after = "LspAttach",
		config = function()
			require("lspsaga").setup({})
		end,
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	},

	{
		"ThePrimeagen/harpoon",
		config = function()
			require("harpoon").setup({
				menu = {
					width = 120,
				},
			})
		end,
	},

	{
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup({
				columns = {
					"icon",
				},
				view_options = {
					show_hidden = true,
				},
			})
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	{ "github/copilot.vim" },

	{
		"jackMort/ChatGPT.nvim",
		event = "VeryLazy",
		config = function()
			require("chatgpt").setup({
				api_key_cmd = "op read op://API/OpenAI/credential --no-newline",
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"folke/trouble.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},

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
			"BufReadPre " .. vim.fn.resolve(vim.fn.expand("~/Documents/Obsidian")) .. "/*",
			"BufNewFile " .. vim.fn.resolve(vim.fn.expand("~/Documents/Obsidian")) .. "/*",
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

			wk.register({
				["<leader>o"] = {
					name = "+Obsidian",
					b = { "<cmd>ObsidianBacklinks<cr>", "Backlinks" },
					c = { "<cmd>lua require('obsidian').util.toggle_checkbox()<cr>", "Toggle Checkbox" },
					d = { "<cmd>ObsidianToday<cr>", "Daily Note" },
					l = { "<cmd>ObsidianLinks<cr>", "Links" },
					m = { "<cmd>ObsidianTemplate<cr>", "Template" },
					n = { "<cmd>ObsidianNew<cr>", "New Note" },
					o = { "<cmd>ObsidianOpen<cr>", "Open Note" },
					p = { "<cmd>ObsidianPasteImg<cr>", "Paste Image" },
					q = { "<cmd>ObsidianQuickSwitch<cr>", "Quick Switch" },
					s = { "<cmd>ObsidianSearch<cr>", "Search" },
					t = { "<cmd>ObsidianTags<cr>", "Tags" },
					w = { "<cmd>ObsidianWorkspace<cr>", "Workspace" },
					y = { "<cmd>ObsidianYesterday<cr>", "Yesterday's Note" },
				},
			})

			wk.register({
				["<leader>o"] = {
					name = "+Obsidian",
					e = {
						function()
							local title = vim.fn.input({ prompt = "Enter title (optional): " })
							vim.cmd("ObsidianExtractNote " .. title)
						end,
						"Extract text into new note",
					},
					l = {
						function()
							vim.cmd("ObsidianLink")
						end,
						"Link text to an existing note",
					},
					n = {
						function()
							vim.cmd("ObsidianLinkNew")
						end,
						"Link text to a new note",
					},
				},
			}, {
				mode = "v",
			})
		end,
		opts = {
			workspaces = {
				{
					name = "Dev",
					path = "~/Documents/Obsidian/Dev",
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
				["<cr>"] = {
					action = function()
						local util = require("obsidian.util")
						if util.cursor_on_markdown_link(nil, nil, true) then
							vim.cmd("ObsidianFollowLink")
						else
							return util.toggle_checkbox()
						end
					end,
					opts = { buffer = true },
				},
			},
			ui = {
				enable = true,
				checkboxes = {
					[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
					["x"] = { char = "", hl_group = "ObsidianDone" },
					[">"] = { char = "", hl_group = "ObsidianRightArrow" },
					["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
				},
				external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
			},
		},
		-- keys = {
		-- 	{
		-- 		"<cr>",
		-- 		function()
		-- 			local util = require("obsidian.util")
		-- 			if util.cursor_on_markdown_link(nil, nil, true) then
		-- 				vim.cmd("ObsidianFollowLink")
		-- 			else
		-- 				util.toggle_checkbox()
		-- 			end
		-- 		end,
		-- 		desc = "Smart action: follow/toggle",
		-- 		ft = "markdown",
		-- 	},
		-- },
	},

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
	},
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })

-- lvim.keys.normal_mode["<S-t>"] = "<cmd>execute 'set colorcolumn='.(&colorcolumn == '' ? '80' : '')<cr>"

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""
vim.g.copilot_filetypes = {
	["*"] = false,
	bash = true,
	css = true,
	go = true,
	lua = true,
	python = true,
	rust = true,
	html = true,
	javascript = true,
	typescript = true,
	javascriptreact = true,
	typescriptreact = true,
}

local cmp = require("cmp")

lvim.builtin.cmp.mapping["<Tab>"] = function(fallback)
	if cmp.visible() then
		cmp.select_next_item()
	else
		local copilot_keys = vim.fn["copilot#Accept"]()
		if copilot_keys ~= "" then
			vim.api.nvim_feedkeys(copilot_keys, "i", true)
		else
			fallback()
		end
	end
end

lvim.keys.insert_mode["<M-]>"] = { "<Plug>(copilot-next)", { silent = true } }
lvim.keys.insert_mode["<M-[>"] = { "<Plug>(copilot-previous)", { silent = true } }
lvim.keys.insert_mode["<M-\\>"] = { "<Cmd>vertical Copilot panel<CR>", { silent = true } }

-- disable indent_blankline for big files
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("IndentBlanklineBigFile", {}),
	pattern = "*",
	callback = function()
		if vim.api.nvim_buf_line_count(0) > 1000 then
			require("indent_blankline.commands").disable()
		end
	end,
})
