declare_plugin_config("formatter")

local util = require("formatter.util")
local formatter = require_plugin("formatter")
formatter.setup({
	filetype = {
		c = {
			function ()
				return {
					exe = "clang-format",
					args = {
						"--style=file",
						-- "--style=file:~/.config/standalone/.clang-format",
						util.escape_path(util.get_current_buffer_file_path()),
						"-i"
					},
				}
			end
		}
	}
})
