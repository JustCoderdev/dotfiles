{ config, lib, pkgs, ... }:

let
	self-manifest = config.common.manifest.self;
	has-de = self-manifest.hardware.graphics.desktop-environment.enable;
in

{
	imports = [
		./audio.nix
		./bluetooth.nix
		./bootloader.nix
		./console.nix
		./dev-input.nix
		./dotfiles-backup.nix
		./fonts.nix
		./locale.nix
		./network.nix
		./nix.nix
		./power.nix
		./plymouth.nix
		./printer.nix
		./secrets.nix
		./shell.nix
		./ssh.nix
		./sudo.nix
		./wakeonlan.nix
	];

	systemd.extraConfig = ''
DefaultTimeoutStopSec=10s
'';

	# Core packages
	environment.systemPackages = with pkgs; [
		rsync unzip zip wget killall
		smartmontools pciutils htop
		ntfs3g # ntfs driver
		vim git
	];


	# Reduce size consumption
	# ------------------------------------------------------------ #

	boot.tmp.cleanOnBoot = lib.mkDefault true;
	programs.nano.enable = lib.mkDefault false;
	documentation.enable = lib.mkDefault false;

	xdg = lib.mkIf (has-de) {
		autostart.enable = lib.mkDefault false;
		icons.enable     = lib.mkDefault false;
		mime.enable      = lib.mkDefault false;
		sounds.enable    = lib.mkDefault false;
	};

	# Random perl remnants
	# <https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/profiles/perlless.nix>
	system.tools.nixos-generate-config.enable = lib.mkDefault false;
	programs.command-not-found.enable = lib.mkDefault false;
	programs.less.lessopen = lib.mkDefault null;
}
