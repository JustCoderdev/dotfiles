{ config, pkgs, settings, ... }:
let
	username = settings.username;
	hostname = settings.hostname;
	dotfiles = settings.dotfiles_path;
in {
	programs.zsh.enable = true;
#	home.packages = with pkgs; [ zsh ];

	# Import configuration from dotfiles
	programs.zsh.initExtra = ''
export DOT_NIXOS=1;
export HOST=${hostname};
export LD_LIBRARY_PATH=/lib64:$LD_LIBRARY_PATH;
source "${dotfiles}/zsh/.zshrc";
'';
	home.file."/home/${username}/.zsh" = {
		source = "${dotfiles}/zsh";
		recursive = true;
	};
}
