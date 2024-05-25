{ pkgs, lib, ... }:

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
		./keyboard.nix
		./pipewire.nix
		./power.nix
		./plymouth.nix
		./printer.nix
		./shell.nix
		./ssh.nix
		./sudo.nix
	];

	options = {
		common.core = {
			bluetooth.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable bluetooth support";
				default = true;
			};

			nvidia.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable nvidia support";
				default = false;
			};
		};
	};

	config = {
		# Core packages
		environment.systemPackages = with pkgs; let
			dotfiles-backup = (callPackage ../../unofficial/dotfiles-backup.nix {});
		in [
			dotfiles-backup
			unzip zip
			vim git
			htop
		];
	};
}
