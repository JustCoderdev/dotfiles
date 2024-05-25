declare_file("themes.lua")


-- TRUECOLOR CAPABILITY --
if os.getenv("COLORTERM") == "truecolor" then
	log("Detected TrueColor capable terminal")
	vim.opt.termguicolors = true
else
	vim.opt.termguicolors = false
end 


-- COLORSCHEME --
local scheme_ok, _ = pcall(vim.cmd, string.format("colorscheme %s", SETTINGS.default_colorscheme))
if(not file_ok) then
	log_error(string.format("Error loading %s colorscheme", SETTINGS.default_colorscheme))
	vim.cmd(string.format(":colorscheme %s", SETTINGS.fallback_colorscheme))
end
