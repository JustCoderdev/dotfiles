{ pkgs, lib, config, settings, ... }:

with lib;

let
	cfg = config.user.app-collection;
in {
	options = {
		user.app-collection = {
			image-editing = mkOption  {
				type = types.bool;
				description = "Add image editing sofware to environment packages";
				default = false;
				example = true;
			};
			video-editing = mkOption {
				type = types.bool;
				description = "Add video editing sofware to environment packages";
				default = false;
				example = true;
			};
			gaming = mkOption {
				type = types.bool;
				description = "Add gaming sofware to environment packages";
				default = false;
				example = true;
			};
			developer = mkOption {
				type = types.bool;
				description = "Add developer sofware to environment packages";
				default = false;
				example = true;
			};
		};
	};

	config = {
		# User account
		users.users.${settings.username} = {
			name = settings.username;
			description = settings.username;

			isNormalUser = true;
			createHome = true;

			extraGroups = [ "networkmanager" "wheel" ];
			# packages = with pkgs; [ ];
		};

		# List packages installed in system profile.
		environment.systemPackages = with pkgs; [
			firefox
			obsidian
			emulsion

			google-chrome

			(mkIf cfg.image-editing [
				gimp
				krita
			])
			(mkIf cfg.video-editing [
				obs-studio # Add to home-manager
				davinci-resolve
			])
			(mkIf cfg.gaming [
				discord

				goverlay
				mangohud

				gamemode #`programs.gamemode.enable = true`
				proton-ge-bin

				steam    #`programs.steam.enable = true`
				heroic   # epic games - gog
				prismlauncher

				lutris
				gamehub
				cartridges
				bottles
			])
			(mkIf cfg.developer [
				putty
				kicad
			])
		];

			# Scuola
			# ciscoPacketTracer8
			# github-desktop
			# vscode
	};
}
