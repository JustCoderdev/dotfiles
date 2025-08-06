{ pkgs, lib, settings, ... }:

{
	imports = [
		./audio.nix
		./avahi.nix
		./bluetooth.nix
		./console.nix
		./dotfiles-backup.nix
		./firewall.nix
		./fonts.nix
		./hardware
		./locale.nix
		./network.nix
		./nix.nix
		./keyboard.nix
		./power.nix
		./plymouth.nix
		./printer.nix
		./secrets.nix
		./shell.nix
		./ssh.nix
		./sudo.nix
		./wakeonlan.nix
	];

	boot.tmp.cleanOnBoot = true;

	# Core packages
	environment.systemPackages = with pkgs; [
		unzip zip wget killall
		rsync smartmontools pciutils dust
		htop btop screen
		ntfs3g # ntfs driver
		vim git
	];
}
