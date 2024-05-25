# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, settings, ... }:

{
	imports = [
		# home-manager.nixosModules.default
		../../modules/system/hardware/numlock.nix

		../../modules/system/desktop/i3.nix

		#../../modules/user/bin/nixos-rebuild.nix
	];

	# VIRTUALIZATION
	virtualisation.virtualbox.guest.enable = true;
	virtualisation.virtualbox.guest.x11 = true;
	# VIRTUALIZATION

	# Bootloader
	boot.loader.grub = {
		enable = true;
		device = "/dev/sda";
		useOSProber = true;
	};


	# Nix settings
	nix.settings.experimental-features = [ "nix-command" "flakes" ];


	# Network settings
	networking = {
		hostName = settings.hostname;	# Define your hostname.
		# wireless.enable = true;	# Enables wireless support via wpa_supplicant.

		# Configure network proxy if necessary
		# proxy.default = "http://user:password@proxy:port/";
		# proxy.noProxy = "127.0.0.1,localhost,internal.domain";

		# Enable networking
		networkmanager.enable = true;
	};

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

	# From 23.05 or older is called `fonts.packages`
	fonts.fonts = with pkgs; [
		roboto-mono
	];

	# Enable the X11 windowing system.
	services.xserver = {
		enable = true;

		# Configure keymap in X11
		layout = "it";
		xkbVariant = "";

		# Enable touchpad support.
		libinput.enable = true;

		# Enable the Xfce Desktop Environment.
		desktopManager.xfce.enable = true;
		displayManager.defaultSession = "none+i3";

		# Enable the GNOME Desktop Environment.
		# desktopManager.gnome.enable = true;
		# displayManager.gdm.enable = true;
	};

	# Remember windows size stuff
	programs.dconf.enable = true;

	# Configure console keymap
	# console.keyMap = "it2";
	console.useXkbConfig = true;

	# Enable CUPS to print documents.
	services.printing.enable = true;

	# Enable bluetooth
	hardware.bluetooth = {
		enable = true;
	};

	# Enable sound with pipewire.
	sound.enable = true;
	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;

		# If you want to use JACK applications, uncomment this
		#jack.enable = true;

		# use the example session manager (no others are packaged yet so this is enabled by default,
		# no need to redefine it in your config for now)
		#media-session.enable = true;
	};

	# USER ACCOUNTS
	# home-manager.users.ryuji = import ./home.nix;
	users.users.ryuji = {
		name = "ryuji";
		description = "ryuji";

		isNormalUser = true;
		createHome = true;

		extraGroups = [ "networkmanager" "wheel" ];
		# packages = with pkgs; [ ];
	};

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# List packages installed in system profile.
	environment.systemPackages = with pkgs; [
		(import ../../modules/user/bin/nixos-rebuild.nix { inherit pkgs; inherit settings; })

		firefox
		docker
		git
		vim
		wget
		man
	];

	environment.shells = with pkgs; [ zsh ];
	users.defaultUserShell = pkgs.zsh;
	programs.zsh.enable = true;


	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = {
	#	 enable = true;
	#	 enableSSHSupport = true;
	# };

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	# services.openssh.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	system.stateVersion = "23.11"; # Did you read the comment?
}
