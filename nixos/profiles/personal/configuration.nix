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
		../../modules/system/hardware/network.nix
		../../modules/system/hardware/numpad.nix
		../../modules/system/hardware/pipewire.nix

		../../modules/system/services/docker.nix
		../../modules/system/services/firewall.nix
		../../modules/system/services/openvpn.nix
		../../modules/system/services/ssh.nix
		../../modules/system/services/virtualbox.nix

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


	# Set your time zone.
	time.timeZone = "Europe/Rome";

	# Select internationalisation properties.
	i18n = {
		defaultLocale = "en_US.UTF-8";
		extraLocaleSettings = {
			LC_ADDRESS = "it_IT.UTF-8";
			LC_IDENTIFICATION = "it_IT.UTF-8";
			LC_MEASUREMENT = "it_IT.UTF-8";
			LC_MONETARY = "it_IT.UTF-8";
			LC_NAME = "it_IT.UTF-8";
			LC_NUMERIC = "it_IT.UTF-8";
			LC_PAPER = "it_IT.UTF-8";
			LC_TELEPHONE = "it_IT.UTF-8";
			LC_TIME = "it_IT.UTF-8";
		};
	};

	# Remember windows size stuff
	programs.dconf.enable = true;

	# Configure console keymap
	# console.keyMap = "it2";
	console.useXkbConfig = true;

	# Enable CUPS to print documents.
	services.printing.enable = true;

	# Set machine hostname
	networking.hostName = settings.hostname;

	# USER ACCOUNT
	users.users.ryuji = {
		name = "ryuji";
		description = "ryuji";

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
