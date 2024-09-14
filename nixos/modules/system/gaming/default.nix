{ config, lib, pkgs, ... }:

let cfg = config.system.gaming; in

{
	imports = [
		./gamemode.nix
		./steam.nix
	];

	options = {
		system.gaming = {
			enable = lib.mkOption {
				type = lib.types.bool;
				description = "Enable gaming software";
				default = false;
			};
		};
	};

	config = lib.mkIf cfg.enable {

		environment.systemPackages = with pkgs; [
			discord # Run with --disable-gpu

			goverlay # Edit overlay
			mangohud # Overlay

			# To use mangohud add to launch options
			# mangohud %command%

			# To use gamemode add to launch options
			# gamemoderun %command%

			# For both
			# gamemoderun mangohud %command%

			heroic         # Epic Games - gog
#			prismlauncher  # Minecraft launcher
			modrinth-app   # Minecraft launcher

			(lutris.override {   # Game hub
				extraLibraries = pkgs: [ ];
				extraPkgs = pkgs: [ pkgs.winetricks ];
			})
#			gamehub  # Game hub

#			bottles     # Vine game manager
#			cartridges  # Game hub
		];
	};
}
