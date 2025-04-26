{ config, lib, pkgs, ... }:

let
	cfg = config.system.desktop.thunar;
in

{
	config = lib.mkIf cfg.enable
	{
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
			tumbler.enable = true; # img thumbnails
			gvfs.enable = true;    # mount, trash, other
		};

		environment.systemPackages = with pkgs; [
			ffmpegthumbnailer # Thunar extensions video thumbnails
		];
	};

	# ------------------------------------------------------------ #

	options.system.desktop.thunar =
	{
		enable = lib.mkOption {
			type = lib.types.bool;
			description = "Enable thunar and related support";
			default = false;
		};
	};
}
