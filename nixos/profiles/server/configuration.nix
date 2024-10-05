# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
	imports = [
		# home-manager.nixosModules.default
		../../modules/common/core

		../../modules/system/bin
		../../modules/system/dev
		../../modules/system/services
	];

	system.stateVersion = "23.11"; # Did you read the comment?
}
