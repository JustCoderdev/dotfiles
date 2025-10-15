
-- USER PREFERENCES

FALLBACK_COLORSCHEME = "habamax" -- retrobox


-- CONST

ENV_COLOR_CAPABLE = os.getenv("COLORTERM") == "truecolor"


-- FUNCTIONS

function require_file(file)
	local file_ok, err = pcall(require, file)
	if (not file_ok) then
		print(string.format("Error loading %s.lua", file))
		print(err)
	end
end


-- INIT

require_file("options")




