{ lib, pkgs, ... }:

{
	imports = [
		./audio.nix
		./bluetooth.nix
		./bootloader.nix
		./console.nix
		./dev-input.nix
		./dotfiles-backup.nix
		./fonts.nix
		./hibernation.nix
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

	services.journald.extraConfig = "SystemMaxUse=500M";

	# Random perl remnants
	# <https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/profiles/perlless.nix>
	system.tools.nixos-generate-config.enable = lib.mkDefault false;
	programs.command-not-found.enable = lib.mkDefault false;
	programs.less.lessopen = lib.mkDefault null;
}
