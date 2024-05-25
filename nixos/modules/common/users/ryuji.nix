{ config, lib, pkgs-unstable, pkgs, settings, ... }:

with lib;

let
	cfg = config.common.users.ryuji;
in {
	config = mkIf cfg.enable {
		users.users.${settings.username} = {
			name = settings.username;
			description = settings.username;

			isNormalUser = true;
			createHome = true;

			# packages = with pkgs; [ ];
			extraGroups = [ "networkmanager" "wheel" ];
		};

		# List packages installed in system profile.
		environment.systemPackages = (mkMerge (with pkgs; [
			[
				firefox
				obsidian
				emulsion
			]

			(mkIf cfg.image-editing [
				gimp
				krita
			])
			(mkIf cfg.video-editing [
				obs-studio # Add to home-manager
				pkgs-unstable.davinci-resolve
			])
			(mkIf cfg.developer [
				putty
				kicad
			])
		]));
	};
}
