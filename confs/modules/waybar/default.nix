{ config, lib, ... }:

let
	inherit (config.jcconfs.host) has-de;

	cfg = config.jcconfs.module.waybar;
in

{
	config = lib.mkIf (cfg.enable && has-de)
	{
		programs.waybar.enable = true;

		home.file =
		{
			".config/waybar/style.css".source = ./style.css;
			".config/waybar/colors.css".source = ./colors.css;
			".config/waybar/config.jsonc".source = ./config.jsonc;
		};
	};

	# ------------------------------------------------------------ #

	options.jcconfs.module.waybar =
	{
		enable = lib.mkEnableOption "waybar wayland navbar custom configuration";
	};
}
