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
		SETTINGS.user_name = "${username}"                                                \n
		SETTINGS.cache_path = "${cachepath}/nvim"                                         \n

		print("hi") \n
		 
		file = "init.lua";                                                                \n
		local require_string = string.format("%s.%s", ${username}, file)                  \n
		local file_ok, _ = pcall(require, require_string)                                 \n
		if (not file_ok) then                                                             \n
			print(string.format(" /!\\  Error loading %s.lua file", require_string)); \n
		end                                                                               \n
	'';

	home.file."/home/${username}/.config/nvim/lua/${username}" = {
		source = "${dotfiles}/nvim/lua/${username}/";
		recursive = true;
	};
	home.file."/home/${username}/.config/nvim/lua/${username}/init.lua" = {
		source = "${dotfiles}/nvim/init.lua";
	};
}
