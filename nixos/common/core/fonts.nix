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
			enableDefaultPackages = false;
			packages = with pkgs;
			[
				dejavu_fonts  # ttf_bitstream_vera
				roboto-mono
				kochi-substitute    # Kochi Mincho, Kochi Gothic
				twitter-color-emoji # Emoji support
			];

			# Remember to also update `confs/stylix/base.nix`
			fontconfig.defaultFonts =
			{
				sansSerif = [ "Kochi Gothic" "DejaVu Sans"  ]; # "Bitstream Vera Sans"
				serif     = [ "Kochi Gothic" "DejaVu Serif" ]; # "Bitstream Vera Serif"
				monospace = [ "Kochi Gothic" "Roboto Mono"  ];
				emoji     = [ "Twitter Color Emoji" ];
				# ⚫ 🔴 🔵
			};
		};
	};

	# ------------------------------------------------------------ #

	options.common.core.fonts =
	{
		enable = lib.mkEnableOption "preferred fonts" // { default = true; };
	};
}
