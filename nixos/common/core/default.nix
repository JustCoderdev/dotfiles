{ pkgs, lib, settings, ... }:

{
	imports = [
		../../unofficial/dotfiles-backup.nix
		./audio.nix
		./bluetooth.nix
		./console.nix
		./firewall.nix
		./fonts.nix
		./locale.nix
		./network.nix
		./nix.nix
		./nvidia.nix
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
		rsync smartmontools pciutils
		htop btop screen
		ntfs3g # ntfs driver
		vim git
	];
}
