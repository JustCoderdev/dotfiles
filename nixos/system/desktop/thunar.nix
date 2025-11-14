{ config, lib, pkgs, ... }:

let
	cfg = config.system.desktop.thunar;
	desktop-cfg = config.system.desktop;
in

{
	config = lib.mkIf (cfg.enable)
	{
		programs.thunar =
		{
			enable = true;
			plugins = with pkgs.xfce; [
				thunar-archive-plugin     # archives context actions
				thunar-media-tags-plugin  # media tags?
				thunar-volman             # drive mounting etc...
			];
		};

		services =
		{
			# Thunar extensions
			tumbler.enable = true; # img thumbnails
			gvfs = {
				enable = true;    # mount, trash, other
				package = lib.mkForce pkgs.gnome.gvfs;
			};
		};

		environment.systemPackages = with pkgs; [
			ffmpegthumbnailer # Thunar extensions video thumbnails
		];
	};

	# ------------------------------------------------------------ #

	options.system.desktop.thunar =
	{
		enable = lib.mkEnableOption "thunar and related support";
	};
}
