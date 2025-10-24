
-- USER PREFERENCES
-- ------------------------------------------------------------

COLORSCHEME = "habamax"
FALLBACK_COLORSCHEME = "retrobox" --sorbet


-- Const
-- ------------------------------------------------------------

-- ENV_COLOR_CAPABLE = os.getenv("COLORTERM") == "truecolor"


-- Functions
-- ------------------------------------------------------------

function declare_file(file) print(string.format("Loading %s.lua", file)) end
function require_file(file)
	local file_ok, err = pcall(require, file)
	if (not file_ok) then
		print(string.format("Error loading %s.lua", file))
		print(err)
	end
end


-- Init
-- ------------------------------------------------------------

require_file("options")


-- Tmp colorscheme
-- ------------------------------------------------------------

vim.cmd(string.format("colorscheme %s", COLORSCHEME))
