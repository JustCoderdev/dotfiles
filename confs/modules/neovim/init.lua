
-- USER PREFERENCES

COLORSCHEME = "habamax"
FALLBACK_COLORSCHEME = "retrobox" --sorbet


-- TMP COLORSCHEME

vim.cmd(string.format("colorscheme %s", COLORSCHEME))


-- CONST

ENV_COLOR_CAPABLE = true
-- ENV_COLOR_CAPABLE = os.getenv("COLORTERM") == "truecolor"
-- print(string.format(" ::: TRUECOLOR %s", ENV_COLOR_CAPABLE))


-- FUNCTIONS

function declare_file(file) print(string.format("  > %s.lua", file)) end
function require_file(file)
	local file_ok, err = pcall(require, file)
	if (not file_ok) then
		print(string.format("v %s.lua", file))
		print(err)
	end
end


-- INIT

require_file("options")
require_file("keymaps")
require_file("plugins")

print(".") -- sacrificed to the buffer gods
