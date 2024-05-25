{ config, lib, pkgs, pkgs-unstable, ... }:

with lib;

let
	cfg = config.system.gaming;
in

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
				example = true;
			};
		};
	};

	config = mkIf cfg.enable {
		environment.systemPackages = [
			(with pkgs; [
				discord

				goverlay
				mangohud

				heroic   # epic games - gog
				prismlauncher

				lutris
				gamehub
				bottles
			])

			(with pkgs-unstable; [
				cartridges
			])
		];
	};
}
