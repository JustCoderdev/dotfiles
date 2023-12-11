declare_file("themes.lua")


-- TRUECOLOR CAPABILITY --

COLOR_CAPABLE = os.getenv("COLORTERM") == "truecolor"
vim.opt.termguicolors = COLOR_CAPABLE
if COLOR_CAPABLE then
	log("?", "Detected TrueColor capable terminal")
else

end


-- 

local function load_scheme(scheme)
	if(scheme.require_truecolor and (not COLOR_CAPABLE)) then
		log_error(string.format("Error loading %s colorscheme: colors not supported", scheme.name))
		return
	end

	local scheme_ok, _ = pcall(vim.cmd, string.format("colorscheme %s", scheme.name))
	if(not scheme_ok) then
		log_error(string.format("Error loading %s colorscheme: not found", scheme.name))
	end
end


-- COLORSCHEME --

load_scheme({ name = "default", require_truecolor = false })
load_scheme(SETTINGS.fallback_colorscheme)
load_scheme(SETTINGS.default_colorscheme)

