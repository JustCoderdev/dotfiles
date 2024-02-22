declare_file("themes.lua")


-- TRUECOLOR CAPABILITY --

vim.opt.termguicolors = COLOR_CAPABLE
if COLOR_CAPABLE then
	log("?", "Detected TrueColor capable terminal")
else
end


--

local function load_scheme(scheme)
	if(scheme.require_truecolor and (not COLOR_CAPABLE)) then
		log_error(string.format("Error loading %s colorscheme: colors not supported", scheme.name))
		return true
	end

	local scheme_ok, _ = pcall(vim.cmd, string.format("colorscheme %s", scheme.name))
	if(not scheme_ok) then
		log_error(string.format("Error loading %s colorscheme: not found", scheme.name))
		return true
	end

	return false
end


-- COLORSCHEME --
if load_scheme(SETTINGS.default_colorscheme) then
	if load_scheme(SETTINGS.fallback_colorscheme) then
		load_scheme({ name = "default", require_truecolor = false })
	end
end


-- vim-whitespace options
vim.cmd("hi ExtraWhitespace ctermbg=red")
vim.cmd([[
let g:better_whitespace_filetypes_blacklist=['diff', 'git', 'help']
let g:current_line_whitespace_disabled_soft=1
]])

-- vim-illuminate options     onedark-darker-bg1
vim.cmd("hi IlluminatedWordText  guibg=#30363f gui=NONE")
vim.cmd("hi IlluminatedWordRead  guibg=#30363f gui=NONE")
vim.cmd("hi IlluminatedWordWrite guibg=#30363f gui=NONE")


