-- STARTUP CONFIGS --

local function protect(tbl) return setmetatable({}, { __index = tbl, __newindex = function(t, key, value) error(string.format( "attempting to change constant %s to %s", tostring(key), tostring(value), 2)) end }) end
COLOR_CAPABLE = os.getenv("COLORTERM") == "truecolor"

-- { name = "onedark", require_truecolor = true }
COLORSCHEME = protect({
	default_colorscheme = { name = "gruvbox", require_truecolor = true },
	fallback_colorscheme = { name = "habamax", require_truecolor = false }
})

--

local error = false
function flag_error() error = true end
function log_base(icon, msg) print(string.format("   %s %s", icon, msg)) end
function log_base_error(msg) print(string.format(" /!\\  %s", msg)); flag_error() end

--
function declare_file(file_name) log_base(">", string.format("Loading %s", file_name)) end
local function require_file(file)
	local file_ok, err = pcall(require, file)
	if (not file_ok) then
		log_base_error(string.format("Error loading %s.lua", file)); flag_error()
		print("Details: " .. err);
	end
end

--
function log(icon, msg) print(string.format("       %s %s", icon, msg)) end
function log_error(msg) print(string.format(" /!\\   ! %s", msg)); flag_error() end

--
function declare_plugin_config(plugin_name) log(">", string.format("Configuring %s", plugin_name)) end
function require_plugin_config(plugin_name)
	local require_string = string.format("plugin_config.%s", plugin_name)
	local file_ok, err = pcall(require, require_string)
	if (not file_ok) then
		log_error(string.format("Error loading %s.lua config", require_string)); flag_error()
		print("Details: " .. err);
	end
end

function require_plugin(plugin_name)
	local file_ok, plugin = pcall(require, plugin_name)
	if (not file_ok) then
		log_error(string.format("Error requiring %s plugin", plugin_name));
		print("Details: " .. plugin);
		flag_error()
	end
	return plugin
end

--
function log_sub(icon, msg) print(string.format("          %s %s", icon, msg)) end
function log_sub_error(msg) print(string.format(" /!\\      ! %s", msg)); flag_error() end

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
Initialising neovim ...
.
 Nvim:   vx.x.x -------
 LuaJIT:  x.x.x -----
.
]])

print("Loading configuration")

require_file("options")
require_file("keymaps")
require_file("plugins")
require_file("themes")

print(".")
-- print("_") -- sacrificed to the buffer gods

if not error then
	vim.cmd("redraw")
end

