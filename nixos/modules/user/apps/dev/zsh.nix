{ config, pkgs, settings, ... }: 

{
	programs.zsh.enable = true;

	home.packages = with pkgs; [
		zsh
	];

	home.file."~" = {
		enable = true;
		source = "${settings.dotfilespath}/zsh/.zshrc";
	}

	home.file."~/.zsh" = {
		enable = true;
		target = "~/.zsh";
		source = "${settings.dotfilespath}/zsh";
		recursive = true;
	}

	users.users.${settings.username}.shell = pkgs.zsh;
}
