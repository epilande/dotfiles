local is_performance_mode_on = false

local function toggle_performance_mode()
	if not is_performance_mode_on then
		-- Turn off performance-heavy settings
		vim.cmd("set norelativenumber")
		vim.cmd("set nocursorline")
		vim.cmd("syntax off")

		-- Disable Treesitter
		vim.cmd([[TSDisable highlight]])
	else
		-- Turn on regular settings
		vim.cmd("set relativenumber")
		vim.cmd("set cursorline")
		vim.cmd("syntax on")

		-- Enable Treesitter
		vim.cmd([[TSEnable highlight]])
	end
	-- Toggle the state
	is_performance_mode_on = not is_performance_mode_on
end

return {
	toggle_performance_mode = toggle_performance_mode,
}
