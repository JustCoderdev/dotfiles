{ config, pkgs, settings, ... }:
let 
	username = settings.username;
	dotfiles = settings.dotfiles_path;
in {
	programs.zsh.enable = true;

	home.packages = with pkgs; [
		zsh
	];

	programs.zsh.initExtra = "source ${dotfiles}/zsh/.zshrc";
# 	home.file."/home/${username}/.zshrc" = {
# 		source = "${dotfiles}/zsh/.zshrc";
# 	};

	home.file."/home/${username}/.zsh" = {
		source = "${dotfiles}/zsh";
		recursive = true;
	};
}
