
-- USER PREFERENCES

COLORSCHEME = "habamax"
FALLBACK_COLORSCHEME = "retrobox" --sorbet


-- CONST

ENV_COLOR_CAPABLE = os.getenv("COLORTERM") == "truecolor"


-- FUNCTIONS

function declare_file(file) print(string.format("Loading %s.lua", file)) end
function require_file(file)
	local file_ok, err = pcall(require, file)
	if (not file_ok) then
		print(string.format("Error loading %s.lua", file))
		print(err)
	end
end


-- INIT

require_file("options")
require_file("keymaps")
require_file("lsp")
require_file("plugins")

print(".") -- sacrificed to the buffer gods

-- TMP COLORSCHEME

vim.cmd(string.format("colorscheme %s", COLORSCHEME))
