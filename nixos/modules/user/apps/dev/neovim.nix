{ config, pkgs, settings, ... }:
let 
	username = settings.username;
	dotfiles = settings.dotfiles_path;
	cachepath = settings.cache_path;
in {
	programs.neovim.enable = true;
	programs.neovim.defaultEditor = true;

#	home.packages = with pkgs; [ neovim ];

	# Import configuration from dotfiles
	home.file."/home/${username}/.config/nvim/init.lua".text = ''
-- NixOS generated config for nvim :P
SETTINGS.user_name = "${username}"
SETTINGS.cache_path = "${cachepath}/nvim"

print("hi")
		 
file = "init.lua";                                                      
local require_string = string.format("%s.%s", ${username}, file)        
local file_ok, _ = pcall(require, require_string)                       
if (not file_ok) then
	print(string.format(" /!\\  Error loading %s.lua file", require_string))
end                                                                     
'';

	home.file."/home/${username}/.config/nvim/lua/${username}" = {
		source = "${dotfiles}/nvim/lua/${username}/";
		recursive = true;
	};
	home.file."/home/${username}/.config/nvim/lua/${username}/init.lua" = {
		source = "${dotfiles}/nvim/init.lua";
	};
}
