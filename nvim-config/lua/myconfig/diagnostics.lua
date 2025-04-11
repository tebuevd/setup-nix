local M = {}

function M.copy_diagnostics_under_cursor()
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local row = cursor_pos[1] - 1

	local diagnostics = vim.diagnostic.get(bufnr, { lnum = row })

	if #diagnostics == 0 then
		vim.notify("No diagnostics found under cursor", vim.log.levels.INFO)
		return
	end

	local diagnostic_messages = {}
	for _, diagnostic in ipairs(diagnostics) do
		table.insert(
			diagnostic_messages,
			string.format("[%s] %s", vim.diagnostic.severity[diagnostic.severity], diagnostic.message)
		)
	end

	local clipboard_text = table.concat(diagnostic_messages, "\n")
	vim.fn.setreg("+", clipboard_text)
	vim.notify(string.format("Copied %d diagnostic(s) to clipboard", #diagnostics), vim.log.levels.INFO)
end

return M
