{ pkgs, settings, ... }:

{
	imports = [
		./bluetooth.nix
		./console.nix
		./firewall.nix
		./fonts.nix
		./locale.nix
		./network.nix
		./nix.nix
		./numpad.nix
		./pipewire.nix
		./plymouth.nix
		./printer.nix
		./ssh.nix
	];

	networking.hostName = settings.hostname;

	# Common packages
	environment.systemPackages = with pkgs; [
		unzip zip

		vim git
		gnumake
	];

	# Use zsh as shell
	environment.shells = with pkgs; [ zsh ];
	users.defaultUserShell = pkgs.zsh;
	programs.zsh.enable = true;
}
