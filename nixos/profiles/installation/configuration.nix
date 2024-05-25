# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, settings, ... }:

{
	imports = [
		# home-manager.nixosModules.default

		../../modules/system/desktop/fonts.nix
		../../modules/system/desktop/i3.nix
		../../modules/system/desktop/x11.nix
		../../modules/system/desktop/xfce.nix

		../../modules/system/hardware/bluetooth.nix
		../../modules/system/hardware/console.nix
		../../modules/system/hardware/locale.nix
		../../modules/system/hardware/network.nix
		../../modules/system/hardware/numpad.nix
		../../modules/system/hardware/pipewire.nix
		../../modules/system/hardware/printer.nix

		../../modules/system/services/ssh.nix

		#../../modules/user/bin/nixos-rebuild.nix
	];

	# List packages installed in system profile.
	environment.systemPackages = with pkgs; [
		(import ../../modules/user/bin/nixos-rebuild.nix { inherit pkgs; inherit settings; })

		firefox
		git
		vim
		wget
		man
	];

	# Nix settings
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# Allow unfree packages
	#nixpkgs.config.allowUnfree = true;

	# Remember windows size stuff
	programs.dconf.enable = true;

	# Set machine hostname
	networking.hostName = settings.hostname;

	# USER ACCOUNT
	users.users.${settings.username} = {
		name = settings.username;
		description = settings.username;

		isNormalUser = true;
		createHome = true;

		extraGroups = [ "networkmanager" "wheel" ];
		# packages = with pkgs; [ ];
	};

	environment.shells = with pkgs; [ zsh ];
	users.defaultUserShell = pkgs.zsh;
	programs.zsh.enable = true;


	system.stateVersion = "23.11"; # Did you read the comment?
}