{ config, pkgs, settings, ... }:
let 
	username = settings.username;
	dotfiles = settings.dotfiles_path;
in {
	programs.neovim.enable = true;
	home.packages = with pkgs; [ neovim ];

	# Import configuration from dotfiles
	home.file."/home/${username}/.config/nvim" = {
		source = "${dotfiles}/nvim";
		recursive = true;
	};
}
