# setting up japanese support
# <https://functor.tokyo/blog/2018-10-01-japanese-on-nixos>

{ config, lib, pkgs, ... }:

let
	cfg = config.common.core.fonts;
in

{
	config = lib.mkIf (cfg.enable)
	{
		fonts =
		{
			packages = with pkgs;
			[
				roboto-mono
				dejavu_fonts
				kochi-substitute # Kochi Mincho and Kochi Gothic
			];

			fontconfig.defaultFonts =
			{
				sansSerif = [ "DejaVu Sans"  "Kochi Gothic" ];
				serif =     [ "DejaVu Serif" "Kochi Gothic" ];
				monospace = [ "Roboto Mono"  "Kochi Gothic" ];
			};
		};
	};

	# ------------------------------------------------------------ #

	options.common.core.fonts =
	{
		enable = lib.mkEnableOption "preferred fonts" // { default = true; };
	};
}
