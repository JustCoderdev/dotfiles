# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, settings, ... }:

{
	imports = [
		# home-manager.nixosModules.default
		../common/core
		../common/users/ryuji.nix

		../../modules/system/desktop/i3.nix
		../../modules/system/desktop/x11.nix
		../../modules/system/desktop/xfce.nix

		../../modules/system/services/docker.nix
		#../../modules/system/services/openvpn.nix
		#../../modules/system/services/virtualbox.nix

		../../modules/system/bin/backlight
		../../modules/system/bin/rebuild-system
	];

	system.nixos.label = "Test_Label";
	system.nixos.tags = [ "test-tag" "test-tag-2" ];

	system.stateVersion = "23.11"; # Did you read the comment?
}
