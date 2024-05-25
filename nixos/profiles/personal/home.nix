{ config, pkgs, settings, ... }:

{
	home.username = settings.username;
	home.homeDirectory = "/home/${settings.username}";
	home-manager.useUserPackages = true;

	imports = [
		../../modules/user/apps/dev/zsh.nix
	]

	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
	home.stateVersion = "23.11";
}
