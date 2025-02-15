{ config, lib, pkgs, ... }:

let
	cfg = config.system.desktop.thunar;
in

{
	config = lib.mkIf cfg.enable {

		programs.thunar = {
			enable = true;
			plugins = with pkgs.xfce; [
				thunar-archive-plugin     # archives context actions
				thunar-media-tags-plugin  # media tags?
				thunar-volman             # drive mounting etc...
			];
		};

		services = {
			# Thunar extensions
			gvfs.enable = true;    # mount, trash, other
			tumbler.enable = true; # img thumbnails
		};

		environment.systemPackages = with pkgs; [
			ffmpegthumbnailer # Thunar extensions video thumbnails
		];
	};
}
