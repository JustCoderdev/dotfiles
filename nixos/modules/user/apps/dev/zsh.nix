{ config, pkgs, settings, ... }:
let 
	username = settings.username;
	dotfiles = settings.dotfiles;
in {
	programs.zsh.enable = true;

	home.packages = with pkgs; [
		zsh
	];

	home.file."/home/${username}" = {
		source = "${dotfiles}/zsh/.zshrc";
	};

	home.file."/home/${username}/.zsh" = {
		source = "${dotfiles}/zsh";
		recursive = true;
	};

	users.users.${username}.shell = pkgs.zsh;
}
