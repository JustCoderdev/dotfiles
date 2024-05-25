{ config, pkgs, settings, ... }:
let 
	username = settings.username;
	dotfiles = settings.dotfiles_path;
in {
	programs.neovim.enable = true;
	programs.neovim.defaultEditor = true;
	programs.neovim.extraLuaConfig = "SETTINGS.user_name = ${username}";

#	home.packages = with pkgs; [ neovim ];

	# Import configuration from dotfiles
	home.file."/home/${username}/.config/neovim" = {
		source = "${dotfiles}/nvim";
		recursive = true;
	};
}
