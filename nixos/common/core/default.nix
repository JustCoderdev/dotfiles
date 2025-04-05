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
		./shell.nix
		./ssh.nix
		./sudo.nix
	];

	# Core packages
	environment.systemPackages = with pkgs; [
		unzip zip
		htop btop
		smartmontools pciutils #ntfs3g
		wget
		vim killall
	];
}
