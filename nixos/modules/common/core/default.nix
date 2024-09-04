{ pkgs, lib, ... }:

{
	imports = [
		../../unofficial/fusuma.nix
		../../unofficial/dotfiles-backup.nix
		./audio.nix
		./bluetooth.nix
		./console.nix
		./firewall.nix
		./fonts.nix
		./fusuma.nix
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

	options = {
		common.core = {
			bluetooth.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable bluetooth support";
				default = false;
			};

			nvidia.enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable nvidia support";
				default = false;
			};

			audio = {
				pipewire.enable = lib.mkOption {
					type = lib.types.bool;
					description = "Enable pipewire support";
					default = false;
				};

				pulseaudio.enable = lib.mkOption {
					type = lib.types.bool;
					description = "Enable pulseaudio support";
					default = false;
				};
			};
		};
	};

	config = {
		# Core packages
		environment.systemPackages = with pkgs; [
			unzip zip
			vim
			smartmontools pciutils #ntfs3g
			htop wget killall
		];
	};
}
