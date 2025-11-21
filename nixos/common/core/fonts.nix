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
			];

			fontconfig.defaultFonts =
			{
				sansSerif = [ "Kochi Gothic" "DejaVu Sans"  ];
				serif =     [ "Kochi Gothic" "DejaVu Serif" ];
				monospace = [ "Kochi Gothic" "Roboto Mono"  ];
			};
		};
	};

	# ------------------------------------------------------------ #

	options.common.core.fonts =
	{
		enable = lib.mkEnableOption "preferred fonts" // { default = true; };
	};
}
