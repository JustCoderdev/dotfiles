{ pkgs, lib, ... }:

with lib;

{
	imports = [
		./bluetooth.nix
		./console.nix
		./firewall.nix
		./fonts.nix
		./locale.nix
		./network.nix
		./nix.nix
		./nvidia.nix
		./numpad.nix
		./pipewire.nix
		./power.nix
		./plymouth.nix
		./printer.nix
		./shell.nix
		./ssh.nix
	];

	options = {
		common.core = {
			bluetooth.enable = mkOption {
				type = types.bool;
				description = "Enable bluetooth support";
				default = true;
			};

			nvidia.enable = mkOption {
				type = types.bool;
				description = "Enable nvidia support";
				default = false;
			};
		};
	};

	config = {
		# Core packages
		environment.systemPackages = with pkgs; [
			gnumake glibcInfo # glibc in nix.nix
			unzip zip
			vim git
			htop
		];
	};
}