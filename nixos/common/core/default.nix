{ pkgs, ... }:

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

	boot.tmp.cleanOnBoot = true;
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

	programs.nano.enable = false;
}
