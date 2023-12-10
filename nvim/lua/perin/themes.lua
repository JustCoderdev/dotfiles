declare_file("themes.lua")


-- TRUECOLOR CAPABILITY --

local color_capable = os.getenv("COLORTERM") == "truecolor"
if color_capable then log("?", "Detected TrueColor capable terminal") end 

vim.opt.termguicolors = color_capable


-- 

local function load_scheme(name)
	local scheme_ok, _ = pcall(vim.cmd, string.format("colorscheme %s", name))

	if(not scheme_ok) then
		log_error(string.format("Error loading %s colorscheme", SETTINGS.default_colorscheme))
	end
end


-- COLORSCHEME --

load_scheme("default")
load_scheme(SETTINGS.fallback_colorscheme)
load_scheme(SETTINGS.default_colorscheme)

