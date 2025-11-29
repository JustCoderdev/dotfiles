declare_file("plugin:lualine")

require("lualine").setup (
{
	options = {
		icons_enabled = false,
		-- theme = (ENV_COLOR_CAPABLE and "gruvbox" or "auto"),
		theme = "auto",

		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },

		always_divide_middle = true,
		globalstatus = true,

		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		}
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			{
				'filename',
				file_status = true,
				newfile_status = true,
				path = 1,
				shorting_target = 40,
			}
		},
		lualine_c = {
			{
				'diagnostics',
				sources = { 'nvim_lsp', 'nvim_diagnostic', 'ale', 'vim_lsp' },
				symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'},
				colored = true,           -- Displays diagnostics status in color if set to true.
				update_in_insert = false, -- Update diagnostics in insert mode.
				always_visible = false,   -- Show diagnostics even if there are none.
			},
			"GetCurrentDiagnosticString()"
		},

		lualine_x = {
			{
				'lsp_status',
				icon = 'x',
				symbols = {
					spinner = { '|', '/', '-', '\\' },
					done = 'O',
					separator = ' ',
				},
				ignore_lsp = {},
				show_name = true,
			},
			"filetype"
		},
		lualine_y = { "progress" },
		lualine_z = { "location" }
	},
	inactive_sections = {},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
})


-- Code below was taken from alisnic (GH) dotfiles
-- thx :p
function GetCurrentDiagnostic()
	local bufnr = 0
	local line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1
	local opts = { ["lnum"] = line_nr }

	local line_diagnostics = vim.diagnostic.get(bufnr, opts)
	if vim.tbl_isempty(line_diagnostics) then return end

	local best_diagnostic = nil

	for _, diagnostic in ipairs(line_diagnostics) do
		if best_diagnostic == nil or diagnostic.severity < best_diagnostic.severity then
			best_diagnostic = diagnostic
		end
	end

	return best_diagnostic
end

function GetCurrentDiagnosticString()
	local diagnostic = GetCurrentDiagnostic()
	if not diagnostic or not diagnostic.message then return end

	local message = vim.split(diagnostic.message, "\n")[1]
	local max_width = vim.api.nvim_win_get_width(0) - 35

	if string.len(message) < max_width then
		return message
	else
		return string.sub(message, 1, max_width) .. "..."
	end
end
