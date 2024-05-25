{ config, lib, pkgs, ... }:

with lib;
let cfg = config.system.gaming; in

{
	imports = [
		./gamemode.nix
		./steam.nix
	];

	options = {
		system.gaming = {
			enable = mkOption {
				type = types.bool;
				description = "Enable gaming software";
				default = false;
			};
		};
	};

	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs; [
			discord

			goverlay # Edit overlay
			mangohud # Overlay

			# To use mangohud add to launch options
			# mangohud %command%

			# To use gamemode add to launch options
			# gamemoderun %command%

			# For both
			# gamemoderun mangohud %command%

			heroic         # Epic Games - gog
			prismlauncher  # Minecraft launcher

			lutris   # Game hub
			gamehub  # Game hub
			bottles  # Vine game manager

			cartridges  # Game hub
		];
	};
}
