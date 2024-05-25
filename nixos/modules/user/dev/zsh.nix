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
source ${dotfiles}/zsh/.zshrc";
'';
#export LD_LIBRARY_PATH:$LD_LIBRARY_PATH:/nix/var/nix/profiles/system/sw/lib;
	home.file."/home/${username}/.zsh" = {
		source = "${dotfiles}/zsh";
		recursive = true;
	};
}
