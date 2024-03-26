{ config, pkgs, inputs, settings, ... }:

{
	home.username = settings.username;
	home.homeDirectory = "/home/${settings.username}";

	programs.home-manager.enable = true;

	imports = [
		../../modules/user/apps/dev/alacritty.nix
		../../modules/user/apps/dev/clang.nix
		../../modules/user/apps/dev/zsh.nix

		../../modules/user/apps/dev/editor/neovim.nix

		../../modules/user/apps/desktop/i3.nix
	];

	home.stateVersion = "23.05";
}
