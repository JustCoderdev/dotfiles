-- STARTUP CONFIGS --

local function protect(tbl) return setmetatable({}, { __index = tbl, __newindex = function(t, key, value) error(string.format("attempting to change constant %s to %s", tostring(key), tostring(value), 2)) end }) end
SETTINGS = protect({
	user_name = "perin",
	default_colorscheme = "neodark",
	fallback_colorscheme = "habamax"
})


--

function declare_file(file_name) print(string.format("    > Loading %s", file_name)) end
function log(msg) print(string.format("       ? %s", msg)) end
function log_error(msg) print(string.format(" /!\\   ! %s", msg)) end
local function require_file(file)
	local require_string = string.format("%s.%s", SETTINGS.user_name, file)
	local file_ok, _ = pcall(require, require_string)
	if(not file_ok) then print(string.format(" /!\\  Error loading %s.lua", require_string)) end
end


-- START ACTUAL CODE --

print([[
/* * * * * * * * * * * * * * * * * * * * * * * * * * * *\
* ##     ## ########  #######  ##     ## #### ##     ## *
* ###    ## ##       ##     ## ##     ##  ##  ###   ### *
* ####   ## ##       ##     ## ##     ##  ##  #### #### *
* ## ### ## ######   ##     ## ##     ##  ##  ## ### ## *
* ##  ##### ##       ##     ##  ##   ##   ##  ##     ## *
* ##    ### ##       ##     ##   ## ##    ##  ##     ## *
* ##     ## ########  #######     ###    #### ##     ## *
\* * * * * * * * * * * * * * * * * * * * * * * * * * * */
.
]])

print([[
Initialising neovim...
.
]])

print(string.format("Loading %s configurations:", SETTINGS.user_name))

require_file("options")
require_file("keymaps")
require_file("plugins")
require_file("themes")

print(".")
print("_") -- sacrificed to the buffer gods
