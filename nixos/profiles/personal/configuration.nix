# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, settings, ... }:

{
	imports = [
		# home-manager.nixosModules.default
		../../modules/common/core
		../../modules/common/users/ryuji.nix
		../../modules/unofficial

		../../modules/system/desktop/i3.nix
		../../modules/system/desktop/ly.nix
		../../modules/system/desktop/x11.nix
		../../modules/system/desktop/xfce.nix

		../../modules/system/gaming
		../../modules/system/services/docker.nix
		#../../modules/system/services/openvpn.nix
		#../../modules/system/services/virtualbox.nix

		../../modules/system/bin/backlight
		../../modules/system/bin/rebuild-system
	];

	system.stateVersion = "23.11"; # Did you read the comment?
}
