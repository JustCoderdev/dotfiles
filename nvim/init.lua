function declare_file(file_name)
	print(string.format("    > Loading %s", file_name))
end
function require_file(user, file)
	local require_string = string.format("%s.%s", user, file)
	local file_ok, _ = pcall(require, require_string)

	if(not file_ok) then
		print(string.format(" /!\\  Error loading %s", require_string))
	end
end


-- STARTUP CONFIGS --
function protect(tbl)
    return setmetatable({}, {
        __index = tbl,
        __newindex = function(t, key, value)
            error(string.format("attempting to change constant %s to %s", tostring(key), tostring(value), 2))
        end
    })
end

SETTINGS = protect({
	user_name = "perin",
	default_colorscheme = "neodark",
	fallback_colorscheme = "slate"
})


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

require_file(SETTINGS.user_name, "options")
require_file(SETTINGS.user_name, "keymaps")
require_file(SETTINGS.user_name, "plugins")
require_file(SETTINGS.user_name, "themes")

print(".")
print("_") -- sacrificed to the buffer gods
