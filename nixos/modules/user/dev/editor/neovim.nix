{ pkgs, settings, ... }:
let
	username = settings.username;
	dotfiles = settings.dotfiles_path;

	cachepath = settings.cache_path;
	configpath = settings.config_path;
in {
#	Requirements:
#		- Clangd
#		- Lua Language Server
#		- Marksman
#		- Astrojs/language-server
#		- Node
#		- Fzf

	programs.neovim.enable = true;
	programs.neovim.defaultEditor = true;

	home.packages = with pkgs; [
		xclip
		xsel
		fzf

		# Parsers
		tree-sitter
		nodejs

		# LSPs
		lua-language-server
		marksman
		nixd

		nodePackages.bash-language-server
		nodePackages.vscode-css-languageserver-bin
		vscode-langservers-extracted
	];

	# Import configuration from dotfiles
	home.file."${configpath}/nvim/init.lua".text = ''
-- NixOS generated config for nvim :P
SETTINGS = {
	user_name = "${username}",
	cache_path = "${cachepath}/nvim"
}

print("Injected by nixOS with love <3")
print(".")

local file = "init";
package.path = package.path .. ";${configpath}/nvim/?.lua"
package.path = package.path .. ";${configpath}/nvim/${username}/?.lua"
package.path = package.path .. ";${configpath}/nvim/${username}/lua/?.lua"
package.path = package.path .. ";${configpath}/nvim/${username}/lua/${username}/?.lua"
print(package.path)
local require_string = string.format("%s.%s", "${username}", file)
local file_ok, err = pcall(require, require_string)
if (not file_ok) then
	print(string.format(" /!\\  Error loading %s.lua file", require_string))
	print("")
	print(err)
end
'';

#	home.file."${configpath}/nvim/lua/${username}" = {
#		source = "${dotfiles}/nvim/lua/${username}/";
#		recursive = true;
#	};
#	home.file."${configpath}/nvim/lua/${username}/init.lua" = {
#		source = "${dotfiles}/nvim/init.lua";
#	};
}
