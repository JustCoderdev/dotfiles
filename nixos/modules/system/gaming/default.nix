{ config, lib, pkgs, ... }:

let
	cfg = config.system.gaming;
	pokemmo-installer = pkgs.callPackage ../../unofficial/pokemmo-installer.nix {
		inherit (pkgs.gnome3) zenity;
		jre = pkgs.jdk11;
	};
in

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

		environment.systemPackages = (lib.mkMerge [
			[
				pokemmo-installer
			]

			(with pkgs; [
				discord # Run with --disable-gpu

				goverlay # Edit overlay
				mangohud # Overlay

				jdk17 # Needed for pokemmo

				# To use mangohud add to launch options
				# mangohud %command%

				# To use gamemode add to launch options
				# gamemoderun %command%

				# For both
				# gamemoderun mangohud %command%

#			heroic         # Epic Games - gog
#			prismlauncher  # Minecraft launcher
				modrinth-app   # Minecraft launcher

				(lutris.override {   # Game hub
					extraLibraries = pkgs: [ ];
					extraPkgs = pkgs: [ pkgs.winetricks ];
				})
#			gamehub  # Game hub

#			bottles     # Vine game manager
#			cartridges  # Game hub
			])
		]);
	};
}
