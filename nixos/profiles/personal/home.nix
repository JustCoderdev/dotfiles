{ config, pkgs, inputs, settings, ... }:

{
	home.username = settings.username;
	home.homeDirectory = "/home/${settings.username}";

	programs.home-manager.enable = true;

	imports = [
		../../modules/user/desktop/i3.nix

		../../modules/user/dev/editor/neovim.nix
		../../modules/user/dev/editor/emacs.nix

		../../modules/user/dev/alacritty.nix
		../../modules/user/dev/clang.nix
		../../modules/user/dev/zsh.nix

		../../modules/user/firefox.nix
	];

	home.stateVersion = "23.05";
}
