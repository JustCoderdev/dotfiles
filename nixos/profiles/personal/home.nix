{ config, pkgs, inputs, settings, ... }:

{
	home.username = settings.username;
	home.homeDirectory = "/home/${settings.username}";

	programs.home-manager.enable = true;

	imports = [
		../../modules/user/apps/dev/zsh.nix
	];

	# home-manager.useGlobalPackages = true;
	# home-manager.useUserPackages = true;

	home.packages = with pkgs; [
		zsh
	];


	home.stateVersion = "23.11";
}
