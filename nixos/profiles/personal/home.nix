{ config, pkgs, inputs, settings, ... }:

{
	home.username = settings.username;
	home.homeDirectory = "/home/${settings.username}";

	programs.home-manager.enable = true;

	imports = [
		../../modules/user/apps/dev/alacritty.nix
		../../modules/user/apps/dev/neovim.nix
		../../modules/user/apps/dev/zsh.nix
	];

	home.stateVersion = "23.05";
}
