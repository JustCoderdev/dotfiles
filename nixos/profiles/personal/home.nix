{ config, pkgs, inputs, settings, ... }:

{
	home.username = settings.username;
	home.homeDirectory = "/home/${settings.username}";

	imports = [
		inputs.home-manager.nixosModules.home-manager
		../../modules/user/apps/dev/zsh.nix
	];

	home-manager.useGlobalPackages = true;
	home-manager.useUserPackages = true;
	# home-manager.users.${settings.username}.imports = [
	# 	../../modules/user/apps/dev/zsh.nix
	# ]


	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
	home.stateVersion = "23.11";
}
