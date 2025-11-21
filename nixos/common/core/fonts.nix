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
				dejavu_fonts roboto-mono
				kochi-substitute # Kochi Mincho, Kochi Gothic
				ipaexfont        # Mincho, Gothic
			];

			fontconfig.defaultFonts =
			{
				sansSerif = [ "DejaVu Sans"  "Kochi Gothic" "Gothic" ];
				serif =     [ "DejaVu Serif" "Kochi Gothic" "Gothic" ];
				monospace = [ "Roboto Mono"  "Kochi Gothic" "Gothic" ];
			};
		};
	};

	# ------------------------------------------------------------ #

	options.common.core.fonts =
	{
		enable = lib.mkEnableOption "preferred fonts" // { default = true; };
	};
}
