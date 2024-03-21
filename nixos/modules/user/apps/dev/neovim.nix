{ config, pkgs, settings, ... }:
let 
	old_username = "perin";
	username = settings.username;
	dotfiles = settings.dotfiles_path;
in {
	programs.neovim.enable = true;
	programs.neovim.defaultEditor = true;

#	home.packages = with pkgs; [ neovim ];

	# Import configuration from dotfiles
	home.file."/home/${username}/.config/neovim/init.lua".text = ''
		SETTINGS = {                              \n
			user_name = ${username},          \n
			default_colorscheme = {           \n
				name = "onedark",         \n
				require_truecolor = true  \n
			},                                \n
			fallback_colorscheme = {          \n
				name = "habamax",         \n
				require_truecolor = false \n
			}                                 \n
		}                                         \n
                                                          \n
		file = "init.lua";                                                                \n
		local require_string = string.format("%s.%s", ${old_username}, file)              \n
		local file_ok, _ = pcall(require, require_string)                                 \n
		if (not file_ok) then                                                             \n
			print(string.format(" /!\\  Error loading %s.lua file", require_string)); \n
		end                                                                               \n
		\n
	'';

	home.file."/home/${username}/.config/neovim/lua/${username}" = {
		source = "${dotfiles}/nvim/lua/${old_username}/";
		recursive = true;
	};
	home.file."/home/${username}/.config/neovim/lua/${username}/init.lua" = {
		source = "${dotfiles}/nvim/init.lua";
	};
}
