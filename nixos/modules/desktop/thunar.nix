{ config, lib, pkgs, ... }:

let
	cfg = config.modules.desktop.thunar;
in

{
	config = lib.mkIf (cfg.enable)
	{
		programs =
		{
			thunar =
			{
				enable = true;
				plugins = with pkgs.xfce; [
					thunar-archive-plugin     # archives context actions
					thunar-media-tags-plugin  # media tags?
					thunar-volman             # drive mounting etc...
				];
			};

			# Required for thunar to retain preferences
			xfconf.enable = true;
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

	options.modules.desktop.thunar =
	{
		enable = lib.mkEnableOption "thunar file manager";
	};
}
