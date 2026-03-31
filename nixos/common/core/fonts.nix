# setting up japanese support
# <https://functor.tokyo/blog/2018-10-01-japanese-on-nixos>

{ config, lib, pkgs, ... }:

let
	cfg = config.common.core.fonts;
in

{
	config = lib.mkIf (cfg.enable)
	{
		# see all installed font families
		# `fc-list : family | sort`
		fonts =
		{
			enableDefaultPackages = false;
			packages = with pkgs;
			[
				ttf_bitstream_vera  # dejavu_fonts
				roboto-mono
				twitter-color-emoji # Emoji support

				# Noto fonts
				noto-fonts-cjk-sans
				noto-fonts-color-emoji
			];

			###########################################################
			# /!\ REMEMBER TO ALSO UPDATE `confs/stylix/default.nix` /!\ #
			###########################################################

			fontconfig.defaultFonts =
			{
				sansSerif = [ "Bitstream Vera Sans"  "Noto Sans CJK JP"  ]; # "DejaVu Sans"
				serif     = [ "Bitstream Vera Serif" "Noto Serif CJK JP" ]; # "DejaVu Serif"
				monospace = [ "Roboto Mono"  "Noto Mono CJK JP"  ];
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
