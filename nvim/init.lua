function require_file(user, file)
	local require_string = string.format("%s.%s", user, file)
	local file_ok, _ = pcall(require, require_string)

	if(file_ok) then
		print(string.format("    > Loading %s", require_string))
	else
		print(string.format(" /!\\  Error loading %s", require_string))
	end
end


-- STARTUP CONFIGS --

local user_name = "perin"


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

print("Initialising neovim...")

print(string.format("Loading %s configurations:", user_name))

require_file(user_name, "options")
require_file(user_name, "keybinding")
require_file(user_name, "plugins")

