{ config, pkgs, settings, ... }:

{
	programs.zsh.enable = false;

	home.packages = with pkgs; [
		zsh
	];

	home.file."~" = {
		source = "${settings.dotfilespath}/zsh/.zshrc";
	};

	home.file."~/.zsh" = {
		source = "${settings.dotfilespath}/zsh";
		recursive = true;
	};

	users.users.${settings.username}.shell = pkgs.zsh;
}
